library ieee;
use ieee.std_logic_1164.all;

entity register_nbit is 
	generic (n:integer:=8);
	port(	input: in std_logic_vector(n-1 downto 0);
			clk: in std_logic;
			synch_rst: in std_logic;
			output: out std_logic_vector(n-1 downto 0));
end register_nbit;

architecture behavioral of register_nbit is
begin
	P1: process(clk)
	begin
		if rising_edge(clk) then
			if synch_rst='1' then
				output<=(others => '0');
			else
				output<=input;
			end if;
		end if;
	end process;
end architecture;

