library ieee;
use ieee.std_logic_1164.all;

entity Full_Adder is
	port( A, B, Carry_in: in std_logic;
		  Sum, Carry_out: out std_logic);
end Full_Adder;

architecture logic_gates of Full_Adder is
signal xor_sig: std_logic;
begin
	xor_sig<=A xor B;
	Sum<= xor_sig xor Carry_in;
	Carry_out<= (xor_sig and Carry_in) or (A and B);
end logic_gates;