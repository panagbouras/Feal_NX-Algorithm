library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity Register_File is
	generic(
	FIFO_WIDTH: natural:=16;
	REG_FILE_DEPTH: natural:=70
	);
	port(
--Inputs
	-- Write ports:
	w_data_0: in std_logic_vector(FIFO_WIDTH-1 downto 0);	-- Write port 0
	w_data_1: in std_logic_vector(FIFO_WIDTH-1 downto 0);	-- Write port 1
	wr_en: in std_logic;			--Enable write
	-- Read ports:
	rd_en: in std_logic;			--Enable read
	-- System characteristics
	synch_rst: in std_logic;	--Synchronous reset
	clk: in std_logic;			--Clock
	mode: in std_logic;			 -- mode='1':decipher, mode='0':encipher
 --Output:
	r_data:out std_logic_vector(FIFO_WIDTH-1 downto 0);		-- Read port-main
	--2 constant outputs:
	r_data_low:out std_logic_vector(4*FIFO_WIDTH-1 downto 0);
	r_data_high:out std_logic_vector(4*FIFO_WIDTH-1 downto 0));
end Register_File;


architecture rtl of Register_File is
	type type_1Dx1D is array (0 to REG_FILE_DEPTH/2-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
	type type_1Dx1Dx1D is array (0 to 1) of type_1Dx1D;
	signal reg_file:type_1Dx1Dx1D:= (others=>(others=>(others=>'0')));	--Signal for 4 Registers of 8-bit width
	-- FIFO controller signals:
	signal w_addr,r_addr: unsigned(integer(log2(real(REG_FILE_DEPTH))) downto 0):=(others => '0');	--Pointers to Read and Write Addresses
	signal Last_8_address: unsigned(integer(log2(real(REG_FILE_DEPTH))) downto 0):=(to_unsigned(REG_FILE_DEPTH/2-1,integer(log2(real(REG_FILE_DEPTH)))+1));	--Pointers to Read and Write Addresses

	signal column : unsigned(0 downto 0):="0";
	signal mode_u:unsigned(0 downto 0);
begin
	--Create Register File:
	Registers:process(clk) begin
		if rising_edge(clk) then
			if synch_rst='1' then
				reg_file<=(others=>(others=>(others=>'0')));	--Clear register File
			elsif wr_en='1' and rd_en='0' then	--use w_en signal
				reg_file(0)(to_integer(w_addr))<=w_data_0;-- use (w_addr,0) to find the Register to write
				reg_file(1)(to_integer(w_addr))<=w_data_1;-- use (w_addr,1) to find the Register to write
			end if;
		end if;
	end process;
	
	mode_u<=(others => mode);
	--Create Register File controller:
	Main_controller:process(clk) begin
		if rising_edge(clk) then
			if synch_rst='1' then
				w_addr<=(others => '0');
				r_addr<=(others => '0');
				column <="0";
				Last_8_address<=to_unsigned(REG_FILE_DEPTH/2-1,integer(log2(real(REG_FILE_DEPTH)))+1);
			else
				if wr_en='1' and rd_en='1' then	-- Setup read in Register File 
					if mode_u="1" then	--Decipher: use LIFO architecture
						r_addr<=w_addr-5;
					else				--Encipher: use FIFO architecture
						r_addr<=(others => '0');
					end if;
					Last_8_address<=w_addr-1;--Use this address to create an output for the last 
					column <=mode_u;
				elsif wr_en='1' then	-- Write in Register File
					w_addr<=w_addr+1;
				elsif rd_en='1' then	--Read from Register file
					if column/=mode_u then
						if mode_u="1" then	--Decipher mode='1': use LIFO architecture
							r_addr<=r_addr-1;
						else				--Encipher mode='0': use FIFO architecture
							r_addr<=r_addr+1;
						end if;
					end if;
					column <= not column ;
				end if;
			end if;
		end if;
	end process;
	
	
	-- MUX for read Port
	r_data<=reg_file(to_integer(column))(to_integer(r_addr));
	--2 constant outputs
	r_data_low<=reg_file(0)(to_integer(Last_8_address-3))&reg_file(1)(to_integer(Last_8_address-3))&reg_file(0)(to_integer(Last_8_address-2))&reg_file(1)(to_integer(Last_8_address-2));
	r_data_high<=reg_file(0)(to_integer(Last_8_address-1))&reg_file(1)(to_integer(Last_8_address-1))&reg_file(0)(to_integer(Last_8_address))&reg_file(1)(to_integer(Last_8_address));

end rtl;