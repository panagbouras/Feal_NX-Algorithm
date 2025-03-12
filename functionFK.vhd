library ieee;
use ieee.std_logic_1164.all;

entity functionFK is 
	port(	A: in std_logic_vector(31 downto 0);
			B: in std_logic_vector(31 downto 0);
			FK: out std_logic_vector(31 downto 0));
end functionFK;

architecture structural of functionFK is

component functionS
	port(	in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			mode: in std_logic;
			output: out std_logic_vector(7 downto 0));
end component;

type xor_array is array (1 to 6) of std_logic_vector (7 downto 0);
signal xor_out : xor_array:= (others=>(others => '0'));
signal out_S01, out_S02, out_S11, out_S12: std_logic_vector(7 downto 0);

begin
	--calculate the starting xor gates
	xor_out(1)<=A(31 downto 24) xor A(23 downto 16);
	xor_out(2)<=A(15 downto 8) xor A(7 downto 0);
	--calculate fk1
	xor_out(3)<=xor_out(2) xor B(31 downto 24);
	U1: entity work.functionS(behavioral) port map(in1=>xor_out(1), in2=>xor_out(3), mode=>'1', output=>out_S11);
	--calculate fk2
	xor_out(4)<=out_S11 xor B(23 downto 16);
	U2: entity work.functionS(behavioral) port map(in1=>xor_out(4), in2=>xor_out(2), mode=>'0', output=>out_S01);
	--calculate fk0
	xor_out(5)<=out_S11 xor B(15 downto 8);
	U0: entity work.functionS(behavioral) port map(in1=>xor_out(5), in2=>A(31 downto 24), mode=>'0', output=>out_S02);
	--calculate fk3
	xor_out(6)<=out_S01 xor B(7 downto 0);
	U3: entity work.functionS(behavioral) port map(in1=>xor_out(6), in2=>A(7 downto 0), mode=>'1', output=>out_S12);
	--update the output
	FK(31 downto 24)<=out_S02;
	FK(23 downto 16)<=out_S11;
	FK(15 downto 8)<=out_S01;
	FK(7 downto 0)<=out_S12;
end architecture;
