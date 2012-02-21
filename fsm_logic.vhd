----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:08:29 02/21/2012 
-- Design Name: 
-- Module Name:    fsm_logic - Behavioral 
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

entity fsm_logic is
    Port ( H_CW, H_CCW, V_CW, V_CCW, LCD_READY : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  LCD_BYTE : out STD_LOGIC_VECTOR(7 downto 0);
			  LCD_START, LCD_ISDATA, LCD_CS : out STD_LOGIC);

end fsm_logic;

architecture Behavioral of fsm_logic is
	signal COUNTER_REG, COUNTER_NEXT : unsigned(8 downto 0);
	signal CUR_PAGE_REG, CUR_PAGE_NEXT, NEW_PAGE_REG, NEW_PAGE_NEXT : STD_LOGIC_VECTOR(3 downto 0);
	signal CUR_COL_REG, CUR_COL_NEXT, NEW_COL_REG, NEW_COL_NEXT : STD_LOGIC_VECTOR(7 downto 0);
	signal LCD_BYTE_REG, LCD_BYTE_NEXT : STD_LOGIC_VECTOR(7 downto 0);
	signal LCD_START_REG, LCD_START_NEXT, LCD_ISDATA_REG, LCD_ISDATA_NEXT, LCD_CS_REG, LCD_CS_NEXT : STD_LOGIC;
	type STATES is (	INIT0, INIT1, INIT2, INIT3, INIT4, INIT5, INIT6, INIT7, INIT8, INIT9,
							INIT10, INIT11, INIT12, INIT13, INIT14, INIT15, IDLE, UP1, UP2, UP3, DOWN1, DOWN2, DOWN3, LEFT1, LEFT2, LEFT3,
							RIGHT1, RIGHT2, RIGHT3, CLEARCURRENT, DRAWNEXT1, DRAWNEXT2, DRAWNEXT3, DRAWNEXT4 );
	signal STATE_REG, STATE_NEXT : STATES;					
begin
	
	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			STATE_REG <= STATE_NEXT;
			LCD_BYTE_REG <= LCD_BYTE_NEXT;
			LCD_START_REG <= LCD_START_NEXT;
			LCD_ISDATA_REG <= LCD_ISDATA_NEXT;
			COUNTER_REG <= COUNTER_NEXT;
			LCD_CS_REG <= LCD_CS_NEXT;
			CUR_PAGE_REG <= CUR_PAGE_NEXT;
			NEW_PAGE_REG <= NEW_PAGE_NEXT;
			CUR_COL_REG <= CUR_COL_NEXT;
			NEW_COL_REG <= NEW_COL_NEXT;
		end if;
	end process;

	LCD_BYTE <= LCD_BYTE_REG;
	LCD_START <= LCD_START_REG;
	
	process(CLK, STATE_REG, LCD_READY, V_CW, V_CCW, H_CW, H_CCW)
	begin
		STATE_NEXT <= STATE_REG;
		LCD_BYTE_NEXT <= "00000000";
		LCD_START_NEXT <= '0';
		LCD_ISDATA_NEXT <= '0';
		LCD_CS_REG <= '1'; -- Set to '0' when writing CMD or DATA.
		CUR_COL_NEXT <= CUR_COL_REG;
		NEW_COL_NEXT <= NEW_COL_REG;
		CUR_PAGE_NEXT <= CUR_PAGE_REG;
		NEW_PAGE_NEXT <= NEW_PAGE_REG;
		
		case STATE_REG is
			when INIT0 =>
				LCD_BYTE_NEXT <= "01000000";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT1;
				end if;
			when INIT1 =>
				LCD_BYTE_NEXT <= "10100001";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT2;
				end if;
			when INIT2 =>
				LCD_BYTE_NEXT <= "11000000";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT3;
				end if;
			when INIT3 =>
				LCD_BYTE_NEXT <= "10100110";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT4;
				end if;
			when INIT4 =>
				LCD_BYTE_NEXT <= "10100010";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT5;
				end if;
			when INIT5 =>
				LCD_BYTE_NEXT <= "00101111";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT6;
				end if;
			when INIT6 =>
				LCD_BYTE_NEXT <= "11111000";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT7;
				end if;
			when INIT7 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT8;
				end if;
			when INIT8 =>
				LCD_BYTE_NEXT <= "00100011";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT9;
				end if;
			when INIT9 =>
				LCD_BYTE_NEXT <= "10000001";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT10;
				end if;
			when INIT10 =>
				LCD_BYTE_NEXT <= "00011111";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT11;
				end if;
			when INIT11 =>
				LCD_BYTE_NEXT <= "10101100";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT12;
				end if;
			when INIT12 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT13;
				end if;
			when INIT13 =>
				LCD_BYTE_NEXT <= "10101111";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT14;
				end if;
				
			when INIT14 =>
				LCD_BYTE_NEXT <= "10110000";
				LCD_START_NEXT <= '1';
				LCD_CS_NEXT <= '0';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= INIT15;
				end if;
					
			when INIT15 =>
				
			when IDLE =>
				LCD_CS_NEXT <= '1';
				if(V_CW = '1') then
					STATE_NEXT <= UP;
				elsif(V_CCW = '1') then
					STATE_NEXT <= DOWN;
				elsif(H_CW ='1') then
					STATE_NEXT <= RIGHT;
				elsif(H_CCW ='1') then
					STATE_NEXT <= LEFT;
				end if;
			when UP =>
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_PAGE_REG = "0000") then
					NEW_PAGE_NEXT <= "0100";
				else
					NEW_PAGE_NEXT <= CUR_PAGE_REG - "0001";
				end if;
			when DOWN =>
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_PAGE_REG = "0100") then
					NEW_PAGE_NEXT <= "0000";
				else
					NEW_PAGE_NEXT <= CUR_PAGE_REG + "0001";
				end if;
			when LEFT =>
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_COL_REG = "00000000") then
					NEW_COL_NEXT <= "10000011";
				else
					NEW_COL_NEXT <= CUR_COL_REG - "00000001";
				end if;
			when RIGHT =>
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_COL_REG = "10000011") then
					NEW_COL_NEXT <= "00000000";
				else
					NEW_COL_NEXT <= CUR_COL_REG + "00000001";
				end if;
			when CLEARCURRENT =>
				LCD_BYTE_NEXT <= "00000000";
				ISDATA_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= DRAWNEXT1;
				end if;
				
			when DRAWNEXT1 => -- Set correct page
				LCD_BYTE_NEXT <= "1011" + NEW_PAGE_REG;
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= DRAWNEXT2;
				end if;
				
			when DRAWNEXT2 =>
				LCD_BYTE_NEXT <= "0001" + NEW_COL_REG(7 downto 4);
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= DRAWNEXT3;
				end if;
				
			when DRAWNEXT3 =>
				LCD_BYTE_NEXT <= "0001" + NEW_COL_REG(3 downto 0);
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= DRAWNEXT4;
				end if;
			
			when DRAWNEXT4 =>
				LCD_BYTE_NEXT <= "11111111";
				LCD_START_NEXT <= '1';
				ISDATA_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= 8;
					STATE_NEXT <= IDLE;
				end if;
			
		end case;
	end process;
	
end Behavioral;

