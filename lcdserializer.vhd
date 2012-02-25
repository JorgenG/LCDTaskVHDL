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
           WRITE_DONE, LCD_CLK : out  STD_LOGIC;
           SI : out  STD_LOGIC;
           CS : out  STD_LOGIC;
			  ISDATA : in STD_LOGIC;
			  A0 : out STD_LOGIC
  );
end lcd_serializer;

architecture Behavioral of lcd_serializer is

	type STATE_TYPE is (idle, prepare, data0, data1, data2, data3, data4, data5, data6, data7,
								wait0, wait1, wait2, wait3, wait4, wait5, wait6, wait7);
	signal STATE_REG, STATE_NEXT : STATE_TYPE;
	signal DATA_NEXT, DATA_REG : STD_LOGIC;
	signal ISDATA_NEXT, ISDATA_REG : STD_LOGIC;
	signal CS_NEXT, CS_REG : STD_LOGIC; -- Chip select is active low.
	signal WRITE_DONE_NEXT, WRITE_DONE_REG, LCD_CLK_REG, LCD_CLK_NEXT : STD_LOGIC;
begin

	process(CLK)
		begin
			if(clk'event and clk='1') then
				STATE_REG <= STATE_NEXT;
				DATA_REG <= DATA_NEXT;
				CS_REG <= CS_NEXT;
				WRITE_DONE_REG <= WRITE_DONE_NEXT;
				LCD_CLK_REG <= LCD_CLK_NEXT;
				ISDATA_REG <= ISDATA_NEXT;
			end if;
      
	end process;
	
	SI <= DATA_REG;
	WRITE_DONE <= WRITE_DONE_REG;
	CS <= CS_REG;
	LCD_CLK <= LCD_CLK_REG;
	A0 <= ISDATA_REG;
	
	process(CLK, STATE_REG)
		begin
			DATA_NEXT <= '0';
			CS_NEXT <= '0';
			LCD_CLK_NEXT <= '0';
			WRITE_DONE_NEXT <= '0';
			STATE_NEXT <= STATE_REG;
			ISDATA_NEXT <= ISDATA;
			
			case STATE_REG is
				when idle =>
					CS_NEXT <= '1';	
					if(LCD_START = '1') then
						STATE_NEXT <= prepare;
					end if;
				
				-- To let the data byte propagate to the LCD_SERIALIZER
				when prepare =>
					CS_NEXT <= '1';
					STATE_NEXT <= data0;
					
				when data0 =>	
					DATA_NEXT <= LCD_BYTE(7);
					STATE_NEXT <= wait0;
					
				when wait0 =>
					DATA_NEXT <= LCD_BYTE(7);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data1;
					
				when data1 =>
					DATA_NEXT <= LCD_BYTE(6);
					STATE_NEXT <= wait1;
					
				when wait1 =>
					DATA_NEXT <= LCD_BYTE(6);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data2;
					
				when data2 =>
					DATA_NEXT <= LCD_BYTE(5);
					STATE_NEXT <= wait2;
					
				when wait2 =>
					DATA_NEXT <= LCD_BYTE(5);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data3;
					
				when data3 =>
					DATA_NEXT <= LCD_BYTE(4);
					STATE_NEXT <= wait3;
					
				when wait3 =>
					DATA_NEXT <= LCD_BYTE(4);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data4;
					
				when data4 =>
					DATA_NEXT <= LCD_BYTE(3);
					STATE_NEXT <= wait4;
					
				when wait4 =>
					DATA_NEXT <= LCD_BYTE(3);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data5;
					
				when data5 =>
					DATA_NEXT <= LCD_BYTE(2);
					STATE_NEXT <= wait5;
					
				when wait5 =>
					DATA_NEXT <= LCD_BYTE(2);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data6;
					
				when data6 =>
					DATA_NEXT <= LCD_BYTE(1);
					STATE_NEXT <= wait6;
					
				when wait6 =>
					DATA_NEXT <= LCD_BYTE(1);
					LCD_CLK_NEXT <= '1';
					STATE_NEXT <= data7;
					
				when data7 =>
					DATA_NEXT <= LCD_BYTE(0);					
					STATE_NEXT <= wait7;	

				when wait7 =>
					DATA_NEXT <= LCD_BYTE(0);
					LCD_CLK_NEXT <= '1';
					WRITE_DONE_NEXT <= '1';
					STATE_NEXT <= idle;
				
			end case;
			
	end process;
	
end Behavioral;
