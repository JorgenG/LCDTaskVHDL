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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity system_logic is
    Port ( H_CW, H_CCW, V_CW, V_CCW, WRITE_DONE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  RESET : out STD_LOGIC;
			  DEBUGLED : out STD_LOGIC_VECTOR(3 downto 0);
			  LCD_BYTE : out STD_LOGIC_VECTOR(7 downto 0);
			  LCD_START, LCD_ISDATA : out STD_LOGIC);

end system_logic;

architecture Behavioral of system_logic is
	constant COLUMNS: integer:=132;
	
	type cmd_array is array(0 to 13) of std_logic_vector(7 downto 0);
	
	signal initcommands : cmd_array;
	
	signal BOOTTIMER_REG, BOOTTIMER_NEXT : integer:=50000; -- Will create a 3.125 ms delay before booting init to avoid chitter.
	signal CMDCOUNTER_REG, CMDCOUNTER_NEXT : integer:=0;
	signal COLCNTR_REG, COLCNTR_NEXT : integer:=COLUMNS-1;
	signal RESET_REG, RESET_NEXT : std_logic;
	signal CUR_PAGE_REG, CUR_PAGE_NEXT, NEW_PAGE_REG, NEW_PAGE_NEXT : integer:=0;
	signal CUR_COL_REG, CUR_COL_NEXT, NEW_COL_REG, NEW_COL_NEXT : integer:=0;
	signal LCD_BYTE_REG, LCD_BYTE_NEXT : STD_LOGIC_VECTOR(7 downto 0);
	signal LCD_START_REG, LCD_START_NEXT, LCD_ISDATA_REG, LCD_ISDATA_NEXT : STD_LOGIC;
	type STATES is (	BOOTTIME, INIT, IDLE, UP, DOWN, LEFT,
							RIGHT, CLEARCURRENT1, CLEARCURRENT2, CLEARCURRENT3, DRAWNEXT1, DRAWNEXT2, DRAWNEXT3, DRAWNEXT4, SETPAGE1, SETPAGE2, SETPAGE3, SETPAGE4, CLEARPAGE1, CLEARPAGE2, CLEARPAGE3, CLEARPAGE4,
							SETCOLP2A, SETCOLP2B, SETCOLP3A, SETCOLP3B, SETCOLP4A, SETCOLP4B);
	signal STATE_REG, STATE_NEXT : STATES;					
begin

	initcommands(0) <= "01000000"; -- Display start line 0
	initcommands(1) <= "10100001"; -- Set ADC to reverse
	initcommands(2) <= "11000000"; -- Set common output COM0 - COM31
	initcommands(3) <= "10100110"; -- Display normal
	initcommands(4) <= "10100010"; -- Set LCD bias to 1/9
	initcommands(5) <= "00101111"; -- Set power control. BOoster regulator and follower on
	initcommands(6) <= "11111000"; -- Set internal booster to 3x/4x
	initcommands(7) <= "00000000"; -- Set internal booster to 3x/4x
	initcommands(8) <= "00100011"; -- Set V0 Voltage regulator for contrast
	initcommands(9) <= "10000001"; -- Set electronic volume mode for contrast
	initcommands(10) <= "00011111";-- Set electronic volume mode for contrast
	initcommands(11) <= "10101100";-- Set static indicator off
	initcommands(12) <= "00000000";-- Set static indicator off
	initcommands(13) <= "10101111";-- Set display on
	
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
			CUR_PAGE_REG <= CUR_PAGE_NEXT;
			NEW_PAGE_REG <= NEW_PAGE_NEXT;
			CUR_COL_REG <= CUR_COL_NEXT;
			NEW_COL_REG <= NEW_COL_NEXT;
			RESET_REG <= RESET_NEXT;
			COLCNTR_REG <= COLCNTR_NEXT;
			CMDCOUNTER_REG <= CMDCOUNTER_NEXT;
			BOOTTIMER_REG <= BOOTTIMER_NEXT;
		end if;
	end process;
	
	process(CLK, WRITE_DONE, V_CW, V_CCW, H_CW, H_CCW)
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
		COLCNTR_NEXT <= COLCNTR_REG;
		CMDCOUNTER_NEXT <= CMDCOUNTER_REG;
		BOOTTIMER_NEXT <= BOOTTIMER_REG;
		
		case STATE_REG is		
			when BOOTTIME =>
				BOOTTIMER_NEXT <= BOOTTIMER_REG - 1;
				if(BOOTTIMER_REG = 0) then
					STATE_NEXT <= INIT;
				end if;
				
			-- Load all commands
			when INIT =>
				LCD_BYTE_NEXT <= initcommands(CMDCOUNTER_REG);
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					CMDCOUNTER_NEXT <= CMDCOUNTER_REG + 1;
					if(CMDCOUNTER_REG = 13) then
						STATE_NEXT <= SETPAGE1;
					end if;
				end if;
				
				-- Select first page for clearing display.
			when SETPAGE1 =>
				LCD_BYTE_NEXT <= "10110000";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= CLEARPAGE1;
				end if;
				
				-- Send zeros to entire page 17*132 times -> 
			when CLEARPAGE1 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';	
				if(WRITE_DONE = '1') then
					COLCNTR_NEXT <= COLCNTR_REG - 1;
					if(COLCNTR_REG = 0) then
						COLCNTR_NEXT <= COLUMNS-1;
						STATE_NEXT <= SETPAGE2;
					end if;
				end if;
			
			when SETPAGE2 =>
				LCD_BYTE_NEXT <= "10110001";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= SETCOLP2A;
				end if;
				
				-- Set column = 0 for writing on new page.
			when SETCOLP2A =>
				LCD_BYTE_NEXT <= "00010000";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= SETCOLP2B;
				end if;
				
			when SETCOLP2B =>
			LCD_BYTE_NEXT <= "00000000";
			LCD_START_NEXT <= '1';
			if(WRITE_DONE = '1') then
				STATE_NEXT <= CLEARPAGE2;
			end if;
				
			when CLEARPAGE2 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';	
				if(WRITE_DONE = '1') then				
					COLCNTR_NEXT <= COLCNTR_REG - 1;
					if(COLCNTR_REG = 0) then
						COLCNTR_NEXT <= COLUMNS-1;
						STATE_NEXT <= SETPAGE3;
					end if;
				end if;
				
			when SETPAGE3 =>
				LCD_BYTE_NEXT <= "10110010";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= SETCOLP3A;
				end if;
				
			when SETCOLP3A =>
				LCD_BYTE_NEXT <= "00010000";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= SETCOLP3B;
				end if;
				
			when SETCOLP3B =>
			LCD_BYTE_NEXT <= "00000000";
			LCD_START_NEXT <= '1';
			if(WRITE_DONE = '1') then
				STATE_NEXT <= CLEARPAGE3;
			end if;
				
			when CLEARPAGE3 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';		
				if(WRITE_DONE = '1') then
					COLCNTR_NEXT <= COLCNTR_REG - 1;
					if(COLCNTR_REG = 0) then
						COLCNTR_NEXT <= COLUMNS-1;
						STATE_NEXT <= SETPAGE4;
					end if;
				end if;
				
			when SETPAGE4 =>
				LCD_BYTE_NEXT <= "10110011";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= SETCOLP4A;
				end if;
				
			when SETCOLP4A =>
				LCD_BYTE_NEXT <= "00010000";
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= SETCOLP4B;
				end if;
				
			when SETCOLP4B =>
			LCD_BYTE_NEXT <= "00000000";
			LCD_START_NEXT <= '1';
			if(WRITE_DONE = '1') then
				STATE_NEXT <= CLEARPAGE4;
			end if;
				
			when CLEARPAGE4 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';		
				LCD_ISDATA_NEXT <= '1';			
				if(WRITE_DONE = '1') then
					COLCNTR_NEXT <= COLCNTR_REG - 1;
					if(COLCNTR_REG = 0) then
						COLCNTR_NEXT <= COLUMNS-1;
						CUR_COL_NEXT <= 0;
						CUR_PAGE_NEXT <= 0;
						NEW_COL_NEXT <= 0;
						NEW_PAGE_NEXT <= 0;
						STATE_NEXT <= DRAWNEXT1;
					end if;
				end if;
				
			when IDLE =>				
				CUR_PAGE_NEXT <= NEW_PAGE_REG;
				CUR_COL_NEXT <= NEW_COL_REG;
				if(V_CW = '1') then
					STATE_NEXT <= DOWN;
				elsif(V_CCW = '1') then
					STATE_NEXT <= UP;
				elsif(H_CW ='1') then
					STATE_NEXT <= RIGHT;
				elsif(H_CCW ='1') then
					STATE_NEXT <= LEFT;
				end if;
			when UP =>
				STATE_NEXT <= CLEARCURRENT1;
				if(CUR_PAGE_REG = 0) then
					NEW_PAGE_NEXT <= 3;
				else
					NEW_PAGE_NEXT <= CUR_PAGE_REG - 1;
				end if;
			when DOWN =>
				STATE_NEXT <= CLEARCURRENT1;
				if(CUR_PAGE_REG = 3) then
					NEW_PAGE_NEXT <= 0;
				else
					NEW_PAGE_NEXT <= CUR_PAGE_REG + 1;
				end if;
			when LEFT =>
				STATE_NEXT <= CLEARCURRENT1;
				if(CUR_COL_REG = 0) then
					NEW_COL_NEXT <= 131;
				else
					NEW_COL_NEXT <= CUR_COL_REG - 1;
				end if;
			when RIGHT =>
				STATE_NEXT <= CLEARCURRENT1;
				if(CUR_COL_REG = 131) then
					NEW_COL_NEXT <= 0;
				else
					NEW_COL_NEXT <= CUR_COL_REG + 1;
				end if;
			when CLEARCURRENT1 =>
				LCD_BYTE_NEXT <= "0001" & std_logic_vector(to_unsigned(CUR_COL_REG, 8)(7 downto 4));
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= CLEARCURRENT2;
				end if;
				
			when CLEARCURRENT2 =>
				LCD_BYTE_NEXT <= "0000" & std_logic_vector(to_unsigned(CUR_COL_REG, 8)(3 downto 0));
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= CLEARCURRENT3;
				end if;
				
			when CLEARCURRENT3 =>
				LCD_BYTE_NEXT <= "00000000";
				LCD_START_NEXT <= '1';
				LCD_ISDATA_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= DRAWNEXT1;
				end if;
				
			when DRAWNEXT1 => -- Set correct page
				debugled <= std_logic_vector(to_unsigned(NEW_PAGE_REG, 4));
				LCD_BYTE_NEXT <= "1011" & std_logic_vector(to_unsigned(NEW_PAGE_REG, 4));
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= DRAWNEXT2;
				end if;
				
			when DRAWNEXT2 =>
				LCD_BYTE_NEXT <= "0001" & std_logic_vector(to_unsigned(NEW_COL_REG, 8)(7 downto 4));
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= DRAWNEXT3;
				end if;
				
			when DRAWNEXT3 =>
				LCD_BYTE_NEXT <= "0000" & std_logic_vector(to_unsigned(NEW_COL_REG, 8)(3 downto 0));
				LCD_START_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= DRAWNEXT4;
				end if;
			
			when DRAWNEXT4 =>
				LCD_BYTE_NEXT <= "11111111";
				LCD_START_NEXT <= '1';
				LCD_ISDATA_NEXT <= '1';
				if(WRITE_DONE = '1') then
					STATE_NEXT <= IDLE;
				end if;
			
		end case;
	end process;
	
end Behavioral;

