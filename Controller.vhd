--M2 and T14 state machine
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is 
	port(	-- Inputs:
			new_in: in std_logic; -- input pin for new crypto
			in32: in std_logic_vector(31 downto 0); --32bits input
			N: in std_logic_vector(3 downto 0); --the input pin of rounds
			clk: in std_logic;
			synch_rst: in std_logic;
			-- Ouputs:
			ack: out std_logic;
			sel: out std_logic_vector(2 downto 0);
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
end Controller;

architecture behavioral of Controller is

type reg_32_array is array (1 to 4) of std_logic_vector (31 downto 0);
type reg_64_array is array (1 to 8) of std_logic_vector (63 downto 0);
type state_type is (none, A, B, C, D, E, F, G, H, I, J, K);

signal pr_state: state_type:=none;
signal nx_state: state_type:=A;
signal plain_reg: reg_64_array:= (others=>(others => '0'));
signal key_reg: reg_32_array:= (others=>(others => '0'));
signal count, count_max: unsigned(5 downto 0):=(others => '0');
signal N_reg: std_logic_vector(4 downto 0):="UUUU0";
signal loaded_reg, valid_out: std_logic;

begin
--Key out:
key_out<=key_reg(1)&key_reg(2)&key_reg(3)&key_reg(4);
--plaintexts out
plain0_out<=plain_reg(1);
plain1_out<=plain_reg(2);
plain2_out<=plain_reg(3);
plain3_out<=plain_reg(4);
plain4_out<=plain_reg(5);
plain5_out<=plain_reg(6);
plain6_out<=plain_reg(7);
plain7_out<=plain_reg(8);
--select signal
sel<=std_logic_vector(count(2 downto 0));

	--process for counter
	P1: process(pr_state, clk)
	begin
		--set the counter_max for each state
		case pr_state is
			when none=>
				count_max<=(others => '0');	
			when A=>
				count_max<=(others => '0');	-- 1 cycle
			when B=>
				count_max<=to_unsigned(2, count_max'length);	-- 3 cycles
			when C=>
				count_max<=(others => '0');	-- 1 cycle
			when D=>
				count_max<=to_unsigned(15, count_max'length); --16 cycles
			when E=>
				count_max<=to_unsigned(2, count_max'length)+ unsigned(N_reg(4 downto 1)); --3+N cycles
			when F=>
				count_max<=(others => '0');	-- 1 cycle
			when G=>
				count_max<=(others => '0');	-- 1 cycle
			when H=>
				count_max<=to_unsigned(13, count_max'length)+ unsigned(N_reg);	-- 15+2N cycles
			when I=>
				count_max<=to_unsigned(15, count_max'length);	-- 16 cycles
			when J=>
				count_max<=(others => '0');	-- 1 cycle
			when K=>
				count_max<=to_unsigned(7, count_max'length);	-- 8 cycles
		end case;
		
		if rising_edge(clk) then
			if pr_state/=nx_state then
				count<=(others => '0');
			elsif count/=count_max then
				count<=count+1;
			end if;
		end if;
	end process;
	
	--State register
	P2: process(clk, synch_rst)
	begin
		if rising_edge(clk) then
			if synch_rst='1' then
				pr_state<=none;
			else
				pr_state<=nx_state;
			end if;
		end if;
	end process;
	
	--State logic
	P3:process(clk)
	begin
		if synch_rst='1' then
			if rising_edge(clk) then
				nx_state<=A;
			end if;
		else
			case pr_state is
				when none=>
					if count=count_max then
						nx_state<=A;
					end if;
				when A=>
					if count=count_max then
						nx_state<=B;
					end if;
				when B=>
					if count=count_max then
						nx_state<=C;
					end if;
				when C=>
					if count=count_max then
						nx_state<=D;
					end if;
				when D=>
					if count=count_max then
						nx_state<=E;
					end if;
				when E=>
					if count=count_max then
						nx_state<=F;
					end if;
				when F=>
					if count=count_max then
						nx_state<=G;
					end if;
				when G=>
					if count=count_max then
						nx_state<=H;
					end if;
				when H=>
					if count=count_max then
						nx_state<=I;
					end if;
				when I=>
					if count=count_max then
						nx_state<=J;
					end if;
				when J=>
					if count=count_max then
						nx_state<=K;
					end if;
				when K=>
					if (count=count_max)and((new_in='1')or(loaded_reg='1')) then
						nx_state<=G;
					else
						nx_state<=K;
					end if;
			end case;
		end if;
	end process;
	
	--Logic for output and registers
	P4:process(clk)
	begin
		if rising_edge(clk) then
			case nx_state is
				when none=>
					null;
				when A=>
					--Initialize the control signals
					control_KS<='0';
					control_crypto<='0';
					act_out<='0';
					wr_en<='0';
					rd_en<='0';
					loaded_reg<='1';
					valid_out<='0';
					--Initialize the Key registers and input 
					key_reg(4)<=in32;
					for i in 1 to 3 loop
						key_reg(i)<=(others => '0');
					end loop;
					--Number of rounds input
					N_reg(4 downto 1)<=N;	
				when B=>
					--Key input
					key_reg(4)<=in32;
					--Shift the register & plaintexts input
					for i in 1 to 3 loop
						key_reg(i)<=key_reg(i+1);
					end loop;
				when C=>
					--control signals
					control_KS<='1';
					wr_en<='1';
					rd_en<='0';
				when D=>
					--control signals
					control_KS<='0';
					wr_en<='1';
					rd_en<='0';
					--Shift the register & plaintexts input
					for i in 0 to 7 loop
						plain_reg(i+1)(3 downto 0)<=in32(4*i+3 downto 4*i);
						for j in 0 to 14 loop
							plain_reg(i+1)(4*j+7 downto 4*j+4)<=plain_reg(i+1)(4*j+3 downto 4*j);
						end loop;
					end loop;
				when E=>
					control_KS<='0';
					wr_en<='1';
					rd_en<='0';
				when F=>
					wr_en<='1';
					rd_en<='1';
				when G=>
					if loaded_reg='1' then
						valid_out<='1';
					else
						valid_out<='0';
					end if;
					control_crypto<='1';
					wr_en<='0';
					rd_en<='1';
					act_out<='0';
				when H=>
					control_crypto<='0';
					wr_en<='0';
					rd_en<='1';
					if new_in='1' then
						loaded_reg<='1';
					else
						loaded_reg<='0';
					end if;
				when I=>
					if loaded_reg='1' then
						ack<='1';
						for i in 0 to 7 loop
							plain_reg(i+1)(3 downto 0)<=in32(4*i+3 downto 4*i);
							for j in 0 to 14 loop
								plain_reg(i+1)(4*j+7 downto 4*j+4)<=plain_reg(i+1)(4*j+3 downto 4*j);
							end loop;
						end loop;
					end if;
				when J=>
					ack<='0';
					wr_en<='0';
					rd_en<='0';	
				when K=>
					act_out<=valid_out;
					wr_en<='1';
					rd_en<='1';
					
			end case;
		end if;
	end process;
end architecture;
					
					
		
		
	
	
