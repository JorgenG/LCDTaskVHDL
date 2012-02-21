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
			  btn : in STD_LOGIC_VECTOR(2 downto 0);
			  debugled1, debugled2 : out std_logic; 
           SCLK : out  STD_LOGIC);
end overall_system;

architecture Behavioral of overall_system is
	signal V_CW_SIG, V_CCW_SIG, H_CW_SIG, H_CCW_SIG, 
				LCD_READY_SIG, LCD_START_SIG : STD_LOGIC;
	signal LCD_BYTE_SIG : STD_LOGIC_VECTOR(7 downto 0);
	signal RESET_LCD_OUT : STD_LOGIC;

begin
	
	RESET_LCD_OUT <= '1';
	SCLK <= CLK;
	
	debugled1 <= '1';
	debugled2 <= '1';

	LCD_SERIALIZER : entity work.lcd_serializer (Behavioral)
	port map(
		clk => CLK,
		lcd_start => LCD_START_SIG,
		lcd_byte => LCD_BYTE_SIG,
		lcd_ready => LCD_READY_SIG,
		cs => CS,
		si => SI
	);
	
	HORIZONTAL_KNOB : entity work.rotation_detector (Behavioral)
	port map(
		clk => CLK,
		rot_a => H_ROT_A,
		rot_b => H_ROT_B,
		cw => H_CW_SIG,
		ccw => H_CCW_SIG	
	);

	VERTICAL_KNOB : entity work.rotation_detector (Behavioral)
	port map(
		clk => CLK,
		rot_a => V_ROT_A,
		rot_b => V_ROT_B,
		cw => V_CW_SIG,
		ccw => V_CCW_SIG
	);
	
	SYSTEM_LOGIC : entity work.system_logic (Behavioral)
	port map(
		clk => CLK,
		h_cw => H_CW_SIG,
		h_ccw => H_CCW_SIG,
		v_cw => V_CW_SIG,
		v_ccw => V_CCW_SIG,
		lcd_byte => LCD_BYTE_SIG,
		lcd_start => LCD_START_SIG,
		lcd_isdata => A0,
		lcd_ready => LCD_READY_SIG
	);

end Behavioral;

