----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:11:50 02/20/2012 
-- Design Name: 
-- Module Name:    lcdserializer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd_serializer is
    Port ( LCD_BYTE : in  STD_LOGIC_VECTOR(7 downto 0);
           LCD_START : in  STD_LOGIC;
			  CLK : in STD_LOGIC;
           LCD_READY : out  STD_LOGIC;
           SI : out  STD_LOGIC;
           CS : out  STD_LOGIC
  );
end lcd_serializer;

architecture Behavioral of lcd_serializer is

	type STATE_TYPE is (idle, data0, data1, data2, data3, data4, data5, data6, data7);
	signal STATE_REG, STATE_NEXT : STATE_TYPE;
	signal DATA_NEXT, DATA_REG : STD_LOGIC;
	signal CS_NEXT, CS_REG : STD_LOGIC; -- Chip select is active low.
	signal LCD_READY_NEXT, LCD_READY_REG : STD_LOGIC;
begin

	process(CLK)
		begin
			if(clk'event and clk='1') then
				STATE_REG <= STATE_NEXT;
				DATA_REG <= DATA_NEXT;
				CS_REG <= CS_NEXT;
				LCD_READY_REG <= LCD_READY_NEXT;
			end if;
      
	end process;
	
	SI <= DATA_REG;
	LCD_READY <= LCD_READY_REG;
	CS <= CS_REG;
	
	process(CLK, STATE_REG)
		begin
			DATA_NEXT <= '0';
			CS_NEXT <= '0';
			LCD_READY_NEXT <= '0';
			STATE_NEXT <= STATE_REG;
			
			case STATE_REG is
				when idle =>
					CS_NEXT <= '1';
					LCD_READY_NEXT <= '1';
					if(LCD_START = '1') then
						STATE_NEXT <= data0;
					end if;
					
				when data0 =>	
					DATA_NEXT <= LCD_BYTE(7);
					STATE_NEXT <= data1;
					
				when data1 =>
					DATA_NEXT <= LCD_BYTE(6);
					STATE_NEXT <= data2;
					
				when data2 =>
					DATA_NEXT <= LCD_BYTE(5);
					STATE_NEXT <= data3;
					
				when data3 =>
					DATA_NEXT <= LCD_BYTE(4);
					STATE_NEXT <= data4;
					
				when data4 =>
					DATA_NEXT <= LCD_BYTE(3);
					STATE_NEXT <= data5;
					
				when data5 =>
					DATA_NEXT <= LCD_BYTE(2);
					STATE_NEXT <= data6;
					
				when data6 =>
					DATA_NEXT <= LCD_BYTE(1);
					STATE_NEXT <= data7;
					
				when data7 =>
					DATA_NEXT <= LCD_BYTE(0);					
					STATE_NEXT <= idle;					
				
			end case;
			
	end process;
	
end Behavioral;