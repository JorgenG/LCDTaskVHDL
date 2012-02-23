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
use IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity system_logic is
    Port ( H_CW, H_CCW, V_CW, V_CCW, LCD_READY : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  RESET : out STD_LOGIC;
			  DEBUGLED : out STD_LOGIC_VECTOR(2 downto 0);
			  LCD_BYTE : out STD_LOGIC_VECTOR(7 downto 0);
			  LCD_START, LCD_ISDATA : out STD_LOGIC);

end system_logic;

architecture Behavioral of system_logic is
	constant N: integer:=16; -- Clock cycles the LCD_Serializer uses from IDle -> idle
	constant DRAWZEROS: integer:=2243;
	signal COUNTER_REG, COUNTER_NEXT : integer:=N;
	signal CLEARCOUNTER_REG, CLEARCOUNTER_NEXT : integer:=DRAWZEROS;
	signal BOOTTIME_REG, BOOTTIME_NEXT : integer:=50;
	signal RESET_REG, RESET_NEXT : std_logic;
	signal CUR_PAGE_REG, CUR_PAGE_NEXT, NEW_PAGE_REG, NEW_PAGE_NEXT : integer:=0;
	signal CUR_COL_REG, CUR_COL_NEXT, NEW_COL_REG, NEW_COL_NEXT : integer:=0;
	signal LCD_BYTE_REG, LCD_BYTE_NEXT : STD_LOGIC_VECTOR(7 downto 0);
	signal LCD_START_REG, LCD_START_NEXT, LCD_ISDATA_REG, LCD_ISDATA_NEXT : STD_LOGIC;
	type STATES is (	BOOTTIME, INIT0, INIT1, INIT2, INIT3, INIT4, INIT5, INIT6, INIT7, INIT8, INIT9,
							INIT10, INIT11, INIT12, INIT13, IDLE, UP, DOWN, LEFT,
							RIGHT, CLEARCURRENT, DRAWNEXT1, DRAWNEXT2, DRAWNEXT3, DRAWNEXT4, SETPAGE1, SETPAGE2, SETPAGE3, SETPAGE4, SENDZEROS1, SENDZEROS2, SENDZEROS3, SENDZEROS4,
							SETCOLP2A, SETCOLP2B, SETCOLP3A, SETCOLP3B, SETCOLP4A, SETCOLP4B);
	signal STATE_REG, STATE_NEXT : STATES;					
begin
	
	LCD_BYTE <= LCD_BYTE_REG;
	LCD_START <= LCD_START_REG;
	LCD_ISDATA <= LCD_ISDATA_REG;
	RESET <= RESET_REG;
	
	process(CLK)
	begin
		if(CLK'event and CLK = '1') then
			STATE_REG <= STATE_NEXT;
			LCD_BYTE_REG <= LCD_BYTE_NEXT;
			LCD_START_REG <= LCD_START_NEXT;
			LCD_ISDATA_REG <= LCD_ISDATA_NEXT;
			COUNTER_REG <= COUNTER_NEXT;
			CUR_PAGE_REG <= CUR_PAGE_NEXT;
			NEW_PAGE_REG <= NEW_PAGE_NEXT;
			CUR_COL_REG <= CUR_COL_NEXT;
			NEW_COL_REG <= NEW_COL_NEXT;
			BOOTTIME_REG <= BOOTTIME_NEXT;
			RESET_REG <= RESET_NEXT;
			CLEARCOUNTER_REG <= CLEARCOUNTER_NEXT;
		end if;
	end process;
	
	process(CLK, STATE_REG, LCD_READY, V_CW, V_CCW, H_CW, H_CCW)
	begin
		STATE_NEXT <= STATE_REG;
		RESET_NEXT <= '1';
		LCD_BYTE_NEXT <= "00000000";
		LCD_START_NEXT <= '0';
		LCD_ISDATA_NEXT <= '0';
		CUR_COL_NEXT <= CUR_COL_REG;
		NEW_COL_NEXT <= NEW_COL_REG;
		CUR_PAGE_NEXT <= CUR_PAGE_REG;
		NEW_PAGE_NEXT <= NEW_PAGE_REG;
		CLEARCOUNTER_NEXT <= CLEARCOUNTER_REG;
		COUNTER_NEXT <= COUNTER_REG;
		
		case STATE_REG is
			when BOOTTIME =>
				BOOTTIME_NEXT <= BOOTTIME_REG - 1;
				RESET_NEXT <= '0';
				if(BOOTTIME_REG = 0) then
					STATE_NEXT <= INIT0;
				end if;
			when INIT0 =>
				LCD_BYTE_NEXT <= "01000000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT1;
				end if;
			when INIT1 =>
				LCD_BYTE_NEXT <= "10100001";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT2;
				end if;
			when INIT2 =>
				LCD_BYTE_NEXT <= "11000000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT3;
				end if;
			when INIT3 =>
				LCD_BYTE_NEXT <= "10100110";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT4;
				end if;
			when INIT4 =>
				LCD_BYTE_NEXT <= "10100010";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT5;
				end if;
			when INIT5 =>
				LCD_BYTE_NEXT <= "00101111";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT6;
				end if;
			when INIT6 =>
				LCD_BYTE_NEXT <= "11111000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT7;
				end if;
			when INIT7 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT8;
				end if;
			when INIT8 =>
				LCD_BYTE_NEXT <= "00100011";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT9;
				end if;
			when INIT9 =>
				LCD_BYTE_NEXT <= "10000001";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT10;
				end if;
			when INIT10 =>
				LCD_BYTE_NEXT <= "00011111";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT11;
				end if;
			when INIT11 =>
				LCD_BYTE_NEXT <= "10101100";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT12;
				end if;
			when INIT12 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= INIT13;
				end if;
			when INIT13 =>
				LCD_BYTE_NEXT <= "10101111";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETPAGE1;
				end if;
				
			when SETPAGE1 =>
				LCD_BYTE_NEXT <= "10110000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SENDZEROS1;
				end if;
				
			when SENDZEROS1 =>
				LCD_BYTE_NEXT <= "01010101";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';	
				CLEARCOUNTER_NEXT <= CLEARCOUNTER_REG - 1;
				if(CLEARCOUNTER_REG = 0) then
					CLEARCOUNTER_NEXT <= DRAWZEROS;
					STATE_NEXT <= SETPAGE2;
				end if;
			
			when SETPAGE2 =>
				LCD_BYTE_NEXT <= "10110001";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETCOLP2A;
				end if;
				
			when SETCOLP2A =>
				LCD_BYTE_NEXT <= "00010000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETCOLP2B;
				end if;
				
			when SETCOLP2B =>
			LCD_BYTE_NEXT <= "00000000";
			LCD_START_NEXT <= '1';
			COUNTER_NEXT <= COUNTER_REG - 1;
			if(COUNTER_REG = 0) then
				COUNTER_NEXT <= N;
				STATE_NEXT <= SENDZEROS2;
			end if;
				
			when SENDZEROS2 =>
				LCD_BYTE_NEXT <= "01010101";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';			
				CLEARCOUNTER_NEXT <= CLEARCOUNTER_REG - 1;
				if(CLEARCOUNTER_REG = 0) then
					CLEARCOUNTER_NEXT <= DRAWZEROS;
					STATE_NEXT <= SETPAGE3;
				end if;
				
			when SETPAGE3 =>
				LCD_BYTE_NEXT <= "10110010";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETCOLP3A;
				end if;
				
			when SETCOLP3A =>
				LCD_BYTE_NEXT <= "00010000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETCOLP3B;
				end if;
				
			when SETCOLP3B =>
			LCD_BYTE_NEXT <= "00000000";
			LCD_START_NEXT <= '1';
			COUNTER_NEXT <= COUNTER_REG - 1;
			if(COUNTER_REG = 0) then
				COUNTER_NEXT <= N;
				STATE_NEXT <= SENDZEROS3;
			end if;
				
			when SENDZEROS3 =>
				LCD_BYTE_NEXT <= "01010101";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';			
				CLEARCOUNTER_NEXT <= CLEARCOUNTER_REG - 1;
				if(CLEARCOUNTER_REG = 0) then
					CLEARCOUNTER_NEXT <= DRAWZEROS;
					STATE_NEXT <= SETPAGE4;
				end if;
				
			when SETPAGE4 =>
				LCD_BYTE_NEXT <= "10110011";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETCOLP4A;
				end if;
				
			when SETCOLP4A =>
				LCD_BYTE_NEXT <= "00010000";
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= SETCOLP4B;
				end if;
				
			when SETCOLP4B =>
			LCD_BYTE_NEXT <= "00000000";
			LCD_START_NEXT <= '1';
			COUNTER_NEXT <= COUNTER_REG - 1;
			if(COUNTER_REG = 0) then
				COUNTER_NEXT <= N;
				STATE_NEXT <= SENDZEROS4;
			end if;
				
			when SENDZEROS4 =>
				LCD_BYTE_NEXT <= "01010101";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';			
				CLEARCOUNTER_NEXT <= CLEARCOUNTER_REG - 1;
				if(CLEARCOUNTER_REG = 0) then
					CLEARCOUNTER_NEXT <= DRAWZEROS;
					STATE_NEXT <= IDLE;
				end if;
				
			when IDLE =>								
				DEBUGLED(2) <= '1';
				--if(V_CW = '1') then
				--	STATE_NEXT <= UP;
				--elsif(V_CCW = '1') then
				--	STATE_NEXT <= DOWN;
				--elsif(H_CW ='1') then
				--	STATE_NEXT <= RIGHT;
				--elsif(H_CCW ='1') then
				--	STATE_NEXT <= LEFT;
				--end if;
			when UP =>
				DEBUGLED(0) <= '1';
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_PAGE_REG = 0) then
					NEW_PAGE_NEXT <= 3;
				else
					NEW_PAGE_NEXT <= CUR_PAGE_REG - 1;
				end if;
			when DOWN =>
				DEBUGLED(0) <= '0';
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_PAGE_REG = 3) then
					NEW_PAGE_NEXT <= 0;
				else
					NEW_PAGE_NEXT <= CUR_PAGE_REG + 1;
				end if;
			when LEFT =>
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_COL_REG = 0) then
					NEW_COL_NEXT <= 131;
				else
					NEW_COL_NEXT <= CUR_COL_REG - 1;
				end if;
			when RIGHT =>
				DEBUGLED(1) <= '1';
				STATE_NEXT <= CLEARCURRENT;
				if(CUR_COL_REG = 131) then
					NEW_COL_NEXT <= 0;
				else
					NEW_COL_NEXT <= CUR_COL_REG + 1;
				end if;
			when CLEARCURRENT =>
				DEBUGLED(1) <= '0';
				LCD_BYTE_NEXT <= "00000000";
				LCD_ISDATA_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= DRAWNEXT1;
				end if;
				
			when DRAWNEXT1 => -- Set correct page
				LCD_BYTE_NEXT <= "10110000"; --& std_logic_vector(to_unsigned(NEW_PAGE_REG), 4);
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= DRAWNEXT2;
				end if;
				
			when DRAWNEXT2 =>
				LCD_BYTE_NEXT <= "00010000"; --& std_logic_vector(to_unsigned(CUR_PAGE_REG), 8)(7 downto 4);
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= DRAWNEXT3;
				end if;
				
			when DRAWNEXT3 =>
				LCD_BYTE_NEXT <= "00000000"; --& std_logic_vector(to_unsigned(CUR_PAGE_REG), 8)(3 downto 0);
				LCD_START_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= DRAWNEXT4;
				end if;
			
			when DRAWNEXT4 =>
				LCD_BYTE_NEXT <= "11111111";
				LCD_START_NEXT <= '1';
				LCD_ISDATA_NEXT <= '1';
				COUNTER_NEXT <= COUNTER_REG - 1;
				if(COUNTER_REG = 0) then
					COUNTER_NEXT <= N;
					STATE_NEXT <= IDLE;
				end if;
			
		end case;
	end process;
	
end Behavioral;

