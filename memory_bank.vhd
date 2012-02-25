
-- Some of the code below is taken from example on
-- http://www.doulos.com/knowhow/vhdl_designers_guide/models/simple_ram_model/
----------------------------------
-- Simple generic RAM Model
--
-- +-----------------------------+
-- |    Copyright 2008 DOULOS    |
-- |   designer :  JK            |
-- +-----------------------------+
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_bank is
    Port ( clk : in STD_LOGIC;
			  address : in  STD_LOGIC_VECTOR(9 downto 0); -- 10 bits for addressing 0 - 527 (132 COL * 4 PAGE - 1)
           data_in : in  STD_LOGIC_VECTOR(7 downto 0);
           data_out : out  STD_LOGIC_VECTOR(7 downto 0);
           write_enable : in  STD_LOGIC);
			  
end memory_bank;

architecture Behavioral of memory_bank is
	type memory is array(0 to 527) of std_logic_vector(7 downto 0);
	
	signal storage : memory;
	signal read_address : std_logic_vector(9 downto 0);
	
begin

	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			if(write_enable = '1') then
				storage(to_integer(unsigned(address))) <= data_in;
			end if;
			read_address <= address;
						
		end if;
	end process;
	
	data_out <= storage(to_integer(unsigned(read_address)));

end Behavioral;

