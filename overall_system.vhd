----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:52:40 02/21/2012 
-- Design Name: 
-- Module Name:    overall_system - Behavioral 
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

entity overall_system is
    Port ( CLK : in  STD_LOGIC;
           H_ROT_A : in  STD_LOGIC;
           H_ROT_B : in  STD_LOGIC;
           V_ROT_A : in  STD_LOGIC;
           V_ROT_B : in  STD_LOGIC;
           SI : out  STD_LOGIC;
           RESETLCD : out  STD_LOGIC;
           CS : out  STD_LOGIC;
           A0 : out  STD_LOGIC;
           SCLK : out  STD_LOGIC;
           DEBUGLED1 : out  STD_LOGIC;
           DEBUGLED2 : out  STD_LOGIC);
end overall_system;

architecture Behavioral of overall_system is

begin
	LCD_SERIALIZER : entity work.lcd_serializer (Behavioral)
	port map(
		clk => CLK,
		reset => open,
		sw => ROT_A,
		db => DB_ROT_A
	);

end Behavioral;

