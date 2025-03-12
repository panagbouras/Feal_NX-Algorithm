library ieee;
use ieee.std_logic_1164.all;

entity Key_Schedule is 
	port(	key: in std_logic_vector(127 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			control: in std_logic;
			Klow: out std_logic_vector(15 downto 0);
			Khigh: out std_logic_vector(15 downto 0));
end Key_Schedule;

architecture structural of Key_Schedule is

component functionFK
	port(	A: in std_logic_vector(31 downto 0);
			B: in std_logic_vector(31 downto 0);
			FK: out std_logic_vector(31 downto 0));
end component;

component register_nbit 
	generic (n:integer:=8);
	port(	input: in std_logic_vector(n-1 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			output: out std_logic_vector(n-1 downto 0));
end component;

component mux21_nbit 
	generic (n:integer:=8);
	port(	in0: in std_logic_vector(n-1 downto 0);
			in1: in std_logic_vector(n-1 downto 0);
			mode: in std_logic;
			output: out std_logic_vector(n-1 downto 0));
end component;

component three_state 
	port(	clk: in std_logic;
			synch_rst: in std_logic;
			output: out std_logic_vector(2 downto 0));
end component;

type mux_array is array (1 to 5) of std_logic_vector (31 downto 0);
type reg_array is array (1 to 3) of std_logic_vector (31 downto 0);
signal mux_out : mux_array:= (others=>(others => '0'));
signal reg_out : reg_array:= (others=>(others => '0'));
signal A0, B0, D0: std_logic_vector(31 downto 0):=(others => '0');
signal Q1, Q2, Q3: std_logic_vector(31 downto 0);
signal xor_out1, xor_out2: std_logic_vector(31 downto 0);
signal out_f: std_logic_vector(31 downto 0); 
signal or_out: std_logic;
signal state: std_logic_vector(2 downto 0);

begin
	--initialize the signals
	Q2<= key(63 downto 32);
	Q3<= key(31 downto 0);
	Q1<= Q2 xor Q3;
	A0<=key(127 downto 96);
	B0<=key(95 downto 64);
	--Create the three state machine
	TS: entity work.three_state(behavioral) port map(clk=>clk, synch_rst=>control, output=>state);
	--Create the Mux 3 to 1
	or_out<=state(1) or control;
	M5: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>Q2, in1=>Q3, mode=>state(0), output=>mux_out(5));
	M4: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>mux_out(5), in1=>Q1, mode=>or_out , output=>mux_out(4));
	--Create the main logic
	xor_out2<=mux_out(3) xor mux_out(4);
	xor_out1<=xor_out2 xor mux_out(2);
	FK: entity work.functionFK(structural) port map(A=>mux_out(1), B=>xor_out1, FK=>out_f);
	--Create the Mux 2 to 1 for B
	R3: entity work.register_nbit(behavioral) generic map(32) port map(input=>out_f, clk=>clk, synch_rst=>synch_rst, output=>reg_out(1));
	M3: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>reg_out(1), in1=>B0, mode=>control, output=>mux_out(3));
	--Create the Mux 2 to 1 for A
	R1: entity work.register_nbit(behavioral) generic map(32) port map(input=>mux_out(3), clk=>clk, synch_rst=>synch_rst, output=>reg_out(3));
	M1: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>reg_out(3), in1=>A0, mode=>control, output=>mux_out(1));
	--Create the Mux 2 to 1 for D
	R2: entity work.register_nbit(behavioral) generic map(32) port map(input=>mux_out(1), clk=>clk, synch_rst=>synch_rst, output=>reg_out(2));
	M2: entity work.mux21_nbit(behavioral) generic map(32) port map(in0=>reg_out(2), in1=>D0, mode=>control, output=>mux_out(2));
	--Update the output
	Klow<=out_f(31 downto 16);
	Khigh<=out_f(15 downto 0);
	
end architecture;
	
	
