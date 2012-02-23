--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:25:26 02/22/2012
-- Design Name:   
-- Module Name:   D:/FPGA Prosjekter/Digitale Systemer/Xilinx/LCDTaskDigSys/tb_system.vhd
-- Project Name:  LCDTaskDigSys
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: overall_system
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_system IS
END tb_system;
 
ARCHITECTURE behavior OF tb_system IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT overall_system
    PORT(
         CLK : IN  std_logic;
         H_ROT_A : IN  std_logic;
         H_ROT_B : IN  std_logic;
         V_ROT_A : IN  std_logic;
         V_ROT_B : IN  std_logic;
         SI : OUT  std_logic;
         RESETLCD : OUT  std_logic;
         CS : OUT  std_logic;
         A0 : OUT  std_logic;
			debugled : OUT STD_LOGIC_VECTOR(2 downto 0);
         SCLK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal H_ROT_A : std_logic := '0';
   signal H_ROT_B : std_logic := '0';
   signal V_ROT_A : std_logic := '0';
   signal V_ROT_B : std_logic := '0';

 	--Outputs
   signal SI : std_logic;
   signal RESETLCD : std_logic;
   signal CS : std_logic;
   signal A0 : std_logic;
   signal SCLK : std_logic;
	signal debugled : std_logic_vector (2 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 62.5 ns;
   constant SCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: overall_system PORT MAP (
          CLK => CLK,
          H_ROT_A => H_ROT_A,
          H_ROT_B => H_ROT_B,
          V_ROT_A => V_ROT_A,
          V_ROT_B => V_ROT_B,
          SI => SI,
          RESETLCD => RESETLCD,
          CS => CS,
          A0 => A0,
          debugled => debugled,
          SCLK => SCLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
