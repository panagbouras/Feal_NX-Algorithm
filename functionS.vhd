library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity functionS is 
	port(	in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			mode: in std_logic;
			output: out std_logic_vector(7 downto 0));
end functionS;

architecture behavioral of functionS is

component cp_adder_8bits
	port(	in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			Sum: out std_logic_vector(7 downto 0));
end component;

signal result: std_logic_vector(7 downto 0);
begin
	U1: entity work.cp_adder_8bits(circuit) port map(in1=>in1, in2=>in2, Cin=>mode, Sum=>result);
	output<=std_logic_vector(rotate_left(unsigned(result), 2));
end architecture;
	