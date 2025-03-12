library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity three_state is 
	port(	clk: in std_logic;
			synch_rst: in std_logic;
			output: out std_logic_vector(2 downto 0));
end three_state;

architecture behavioral of three_state is
signal inner: std_logic_vector(2 downto 0):="001";
begin
	P1: process(clk)
	begin
		if rising_edge(clk) then
			if synch_rst='1' then
				inner<="100";
			else
				inner<=std_logic_vector(rotate_left(unsigned(inner), 1));
			end if;
			
		end if;
	end process;
	output<=inner;
end architecture;