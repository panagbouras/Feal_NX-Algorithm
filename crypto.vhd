library ieee;
use ieee.std_logic_1164.all;

entity crypto is 
	port(	first_keys: in std_logic_vector(63 downto 0);
			last_keys: in std_logic_vector(63 downto 0);
			key: in std_logic_vector(15 downto 0);
			input: in std_logic_vector(63 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			control: in std_logic;
			output: out std_logic_vector(63 downto 0));
end crypto;

architecture structural of crypto is

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

component functionF  
	port(	A: in std_logic_vector(31 downto 0);
			B: in std_logic_vector(15 downto 0);
			F: out std_logic_vector(31 downto 0));
end component;

type xor_array is array (2 to 4) of std_logic_vector (31 downto 0);
type reg_array is array (1 to 2) of std_logic_vector (31 downto 0);
signal xor_out : xor_array:= (others=>(others => '0'));
signal reg_out : reg_array:= (others=>(others => '0'));
signal xor_out1, xor_out5: std_logic_vector (63 downto 0);
signal mux_out1, mux_out2: std_logic_vector (31 downto 0);
signal out_f: std_logic_vector (31 downto 0);

begin
	--Pre Processing Stage
	xor_out1<=input xor first_keys;
	xor_out(2)<= xor_out1(63 downto 32) xor xor_out1(31 downto 0);
	--Iterative Calculation
	M1: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>reg_out(1), in1=>xor_out(2), mode=>control, output=>mux_out1);
	R2: entity work.register_nbit(behavioral) generic map(32) port map(input=>mux_out1, clk=>clk, synch_rst=>synch_rst, output=>reg_out(2));
	M2: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>reg_out(2), in1=>xor_out1(63 downto 32), mode=>control, output=>mux_out2);
	F:  entity work.functionF(structural) port map(A=>mux_out1, B=>key, F=>out_f);
	xor_out(3)<=mux_out2 xor out_f;
	--Post Processing
	R1: entity work.register_nbit(behavioral) generic map(32) port map(input=>xor_out(3), clk=>clk, synch_rst=>synch_rst, output=>reg_out(1));
	xor_out(4)<=xor_out(3) xor mux_out1;
	xor_out5<= last_keys xor (xor_out(3)&xor_out(4));
	--Update the output
	output<=xor_out5;
end architecture;
