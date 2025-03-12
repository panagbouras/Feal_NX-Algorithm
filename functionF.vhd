library ieee;
use ieee.std_logic_1164.all;

entity functionF is 
	port(	A: in std_logic_vector(31 downto 0);
			B: in std_logic_vector(15 downto 0);
			F: out std_logic_vector(31 downto 0));
end functionF;

architecture structural of functionF is

component functionS
	port(	in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			mode: in std_logic;
			output: out std_logic_vector(7 downto 0));
end component;

type xor_array is array (1 to 4) of std_logic_vector (7 downto 0);
signal xor_out : xor_array:= (others=>(others => '0'));
signal out_S01, out_S02, out_S11, out_S12: std_logic_vector(7 downto 0);

begin
	--xor gates
	xor_out(1)<=A(23 downto 16) xor B(15 downto 8);
	xor_out(2)<=A(15 downto 8) xor B(7 downto 0);
	xor_out(3)<=xor_out(1) xor A(31 downto 24);
	xor_out(4)<=xor_out(2) xor A(7 downto 0);
	--calculate f1
	U1: entity work.functionS(behavioral) port map(in1=>xor_out(3), in2=>xor_out(4), mode=>'1', output=>out_S11);
	--calculate f2
	U2: entity work.functionS(behavioral) port map(in1=>out_S11, in2=>xor_out(4), mode=>'0', output=>out_S01);
	--calculate f0
	U0: entity work.functionS(behavioral) port map(in1=>out_S11, in2=>A(31 downto 24), mode=>'0', output=>out_S02);
	--calculate f3
	U3: entity work.functionS(behavioral) port map(in1=>out_S01, in2=>A(7 downto 0), mode=>'1', output=>out_S12);
	--update the output
	F(31 downto 24)<=out_S02;
	F(23 downto 16)<=out_S11;
	F(15 downto 8)<=out_S01;
	F(7 downto 0)<=out_S12;	
end architecture;
	
