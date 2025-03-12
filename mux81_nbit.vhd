library ieee;
use ieee.std_logic_1164.all;

entity mux81_nbit is 
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
end mux81_nbit;

architecture behavioral of mux81_nbit is
begin
	output<=in0 when mode="000" else
			in1 when mode="001" else
			in2 when mode="010" else
			in3 when mode="011" else
			in4 when mode="100" else
			in5 when mode="101" else
			in6 when mode="110" else
			in7;
	
				
				
end architecture;