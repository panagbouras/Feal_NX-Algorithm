library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FEAL_NX is 
	port(	-- Inputs:
			new_in: in std_logic; -- input pin for new crypto
			in32: in std_logic_vector(31 downto 0); --32bits input
			mode: in std_logic; --Cipher or decipher
			N: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			--Outputs
			ack: out std_logic;
			act_out: out std_logic;
			out64: out std_logic_vector(63 downto 0));
end FEAL_NX;

architecture structural of FEAL_NX is

component Key_Schedule 
	port(	key: in std_logic_vector(127 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			control: in std_logic;
			Klow: out std_logic_vector(15 downto 0);
			Khigh: out std_logic_vector(15 downto 0));
end component;

component Controller 
	port(	-- Inputs:
			new_in: in std_logic; -- input pin for new crypto
			in32: in std_logic_vector(31 downto 0); --32bits input
			N: in std_logic_vector(3 downto 0); --the input pin of rounds
			clk: in std_logic;
			synch_rst: in std_logic;
			-- Ouputs:
			ack: out std_logic;
			sel: out std_logic_vector(1 downto 0);
			control_KS: out std_logic; -- the control signal for KS
			control_crypto: out std_logic; --the control signal for crypto
			wr_en: out std_logic;
			rd_en: out std_logic;
			key_out: out std_logic_vector(127 downto 0); --the key reg
			act_out: out std_logic; --activate the output
			--the plaintext regs
			plain0_out: out std_logic_vector(63 downto 0);
			plain1_out: out std_logic_vector(63 downto 0);
			plain2_out: out std_logic_vector(63 downto 0);
			plain3_out: out std_logic_vector(63 downto 0);
			plain4_out: out std_logic_vector(63 downto 0);
			plain5_out: out std_logic_vector(63 downto 0);
			plain6_out: out std_logic_vector(63 downto 0);
			plain7_out: out std_logic_vector(63 downto 0));
end component;

component crypto
	port(	first_keys: in std_logic_vector(63 downto 0);
			last_keys: in std_logic_vector(63 downto 0);
			key: in std_logic_vector(15 downto 0);
			input: in std_logic_vector(63 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			control: in std_logic;
			output: out std_logic_vector(63 downto 0));
end component;

component register_file
	generic(
	FIFO_WIDTH: natural:=16;
	REG_FILE_DEPTH: natural:=70
	);
	port(
--Inputs
	-- Write ports:
	w_data_0: in std_logic_vector(FIFO_WIDTH-1 downto 0);	-- Write port 0
	w_data_1: in std_logic_vector(FIFO_WIDTH-1 downto 0);	-- Write port 1
	wr_en: in std_logic;			--Enable write
	-- Read ports:
	rd_en: in std_logic;			--Enable read
	-- System characteristics
	synch_rst: in std_logic;	--Synchronous reset
	clk: in std_logic;			--Clock
	mode: in std_logic;			 -- mode='1':decipher, mode='0':encipher
 --Output:
	r_data:out std_logic_vector(FIFO_WIDTH-1 downto 0);		-- Read port-main
	--2 constant outputs:
	r_data_low:out std_logic_vector(4*FIFO_WIDTH-1 downto 0);
	r_data_high:out std_logic_vector(4*FIFO_WIDTH-1 downto 0));
end component;

component mux21_nbit 
	generic (n:integer:=8);
	port(	in0: in std_logic_vector(n-1 downto 0);
			in1: in std_logic_vector(n-1 downto 0);
			mode: in std_logic;
			output: out std_logic_vector(n-1 downto 0));
end component;

component register_nbit
	generic (n:integer:=8);
	port(	input: in std_logic_vector(n-1 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			output: out std_logic_vector(n-1 downto 0));
end component;

component mux81_nbit 
	generic (n:integer:=8);
	port(	in0: in std_logic_vector(n-1 downto 0);
			in1: in std_logic_vector(n-1 downto 0);
			in2: in std_logic_vector(n-1 downto 0);
			in3: in std_logic_vector(n-1 downto 0);
			in4: in std_logic_vector(n-1 downto 0);
			in5: in std_logic_vector(n-1 downto 0);
			in6: in std_logic_vector(n-1 downto 0);
			in7: in std_logic_vector(n-1 downto 0);
			mode: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(n-1 downto 0));
end component;


type sig_64_array is array (1 to 8) of std_logic_vector (63 downto 0);

signal keys_low, keys_high: std_logic_vector(63 downto 0);
signal mux21_first, mux21_last: std_logic_vector(63 downto 0);
signal plain_sig, out_sig, out_reg, out_mux21: sig_64_array:= (others=>(others => '0'));
signal control_KS,control_crypto,wr_en,rd_en, active_out: std_logic:='0';
signal key: std_logic_vector(127 downto 0);
signal K_low, K_high:std_logic_vector(15 downto 0);
signal r_data: std_logic_vector(15 downto 0);
signal sel: std_logic_vector(2 downto 0);

begin
	State_Machine:  entity work.Controller(behavioral) port map(	new_in=>new_in, in32=>in32, N=>N, clk=>clk, synch_rst=>synch_rst, ack=>ack, sel=>sel, 
																	control_KS=>control_KS, control_crypto=>control_crypto, wr_en=>wr_en, rd_en=>rd_en, 
																	key_out=>key, act_out=>active_out, plain0_out=>plain_sig(1), plain1_out=>plain_sig(2),
																	plain2_out=>plain_sig(3), plain3_out=>plain_sig(4), plain4_out=>plain_sig(5), 
																	plain5_out=>plain_sig(6), plain6_out=>plain_sig(7), plain7_out=>plain_sig(8));
	Key_Scheduler:  entity work.Key_Schedule(structural) port map(key=>key, clk=>clk, synch_rst=>synch_rst, control=>control_KS, Klow=>K_low, Khigh=>K_high);
	File_Register:  entity work.register_file(rtl) port map(w_data_0=>K_low, w_data_1=>K_high, wr_en=>wr_en, rd_en=>rd_en, synch_rst=>synch_rst, clk=>clk, mode=>mode,
															r_data=>r_data, r_data_low=>keys_low, r_data_high=>keys_high);
	FIRST_MUX21: 	entity work.mux21_nbit(behavioral) generic map(64) port map(in0=>keys_low, in1=>keys_high, mode=>mode, output=>mux21_first);
	LAST_MUX21: 	entity work.mux21_nbit(behavioral) generic map(64) port map(in0=>keys_high, in1=>keys_low, mode=>mode, output=>mux21_last);
	GEN_LOOP:		for i in 1 to 8 generate
						Crypto_Circuit: entity work.crypto(structural) port map(first_keys=>mux21_first, last_keys=>mux21_last, key=>r_data, input=>plain_sig(i),
																				clk=>clk, synch_rst=>synch_rst, control=>control_crypto, output=>out_sig(i));
						Mux21_out: 	entity work.mux21_nbit(behavioral) generic map(64) port map(in0=>out_sig(i), in1=>out_reg(i), mode=>active_out, output=>out_mux21(i));
						Out_Register: entity work.register_nbit(behavioral) generic map(64) port map(input=>out_mux21(i), clk=>clk, synch_rst=>synch_rst, output=>out_reg(i));
					end generate;
					
					Mux81_out: 	entity work.mux81_nbit(behavioral) generic map(64) port map(in0=>out_reg(1), in1=>out_reg(2), in2=>out_reg(3), in3=>out_reg(4),
																							in4=>out_reg(5), in5=>out_reg(6), in6=>out_reg(7), in7=>out_reg(8), 
																							mode=>sel, output=>out64);
	act_out<=active_out;
end architecture;
	

