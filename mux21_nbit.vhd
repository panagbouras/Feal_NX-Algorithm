library ieee;
use ieee.std_logic_1164.all;

entity mux21_nbit is 
	generic (n:integer:=8);
	port(	in0: in std_logic_vector(n-1 downto 0);
			in1: in std_logic_vector(n-1 downto 0);
			mode: in std_logic;
			output: out std_logic_vector(n-1 downto 0));
end mux21_nbit;

architecture behavioral of mux21_nbit is
begin
	output<=	in0 when mode='0' else
				in1;
end architecture;