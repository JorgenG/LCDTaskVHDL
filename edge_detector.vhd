----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:51:12 02/20/2012 
-- Design Name: 
-- Module Name:    edge_detector - Behavioral 
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

entity rotation_detector is
    Port ( ROT_A : in  STD_LOGIC;
           ROT_B : in  STD_LOGIC;
			  CLK : in  STD_LOGIC;
           CW, CCW : out  STD_LOGIC
           );
end rotation_detector;

architecture Behavioral of rotation_detector is
	type STATES is (idle, cw_state, ccw_state);
	signal STATE_REG, STATE_NEXT : STATES;
	signal DELAY_A_REG : STD_LOGIC;
	signal DB_ROT_A, DB_ROT_B, CW_REG, CW_NEXT, CCW_REG, CCW_NEXT : STD_LOGIC;
	signal TICK_A : STD_LOGIC;
begin

	DEBOUNCE_A : entity work.db_fsm (arch)
	port map(
		clk => CLK,
		reset => '0',
		sw => ROT_A,
		db => DB_ROT_A
	);
	 
	DEBOUNCE_B : entity work.db_fsm (arch)
	port map(
		clk => CLK,
		reset => '0',
		sw => ROT_B,
		db => DB_ROT_B
	);

	process(clk)
	begin
		if(clk'event and clk='1') then
			DELAY_A_REG <= DB_ROT_A;
			STATE_REG <= STATE_NEXT;
			CW_REG <= CW_NEXT;
			CCW_REG <= CCW_NEXT;
		end if;
	end process;
	
	TICK_A <= (not DELAY_A_REG) and DB_ROT_A;
	CW <= CW_REG;
	CCW <= CCW_REG;

	process(CLK, STATE_REG, TICK_A)
	begin
		CW_NEXT <= '0';
		CCW_NEXT <= '0';
		STATE_NEXT <= STATE_REG;
		
		case STATE_REG is
			when idle =>
				if(TICK_A = '1' and DB_ROT_B ='0') then
					STATE_NEXT <= cw_state;
				elsif(TICK_A = '1' and DB_ROT_B ='1') then
					STATE_NEXT <= ccw_state;
				end if;
			when cw_state =>
				CW_NEXT <= '1';
			when ccw_state =>
				CCW_NEXT <= '1';
		end case;
	end process;

end Behavioral;

