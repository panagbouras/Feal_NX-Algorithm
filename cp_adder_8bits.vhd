library ieee;
use ieee.std_logic_1164.all;


entity cp_adder_8bits is
	port(	in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			Sum: out std_logic_vector(7 downto 0));
end cp_adder_8bits;

architecture circuit of cp_adder_8bits is

component Full_Adder
	port( A, B, Carry_in: in std_logic;
		  Sum, Carry_out: out std_logic);
end component;

signal Carry: std_logic_vector(7 downto 0);
begin
	
	U1: entity work.Full_Adder(logic_gates) port map(A=>in1(0), B=>in2(0), Carry_in=>Cin, Sum=>Sum(0), Carry_out=>Carry(0));
	
	generate_label:
		for i in 1 to 7 generate
			U1: entity work.Full_Adder(logic_gates) port map(A=>in1(i), B=>in2(i), Carry_in=>Carry(i-1), Sum=>Sum(i), Carry_out=>Carry(i));
		end generate;
		
end circuit;