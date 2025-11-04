----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2025 09:44:13
-- Design Name: 
-- Module Name: tristate_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity tristate_tb is
--  Port ( );
end tristate_tb;

architecture Behavioral of tristate_tb is
    
	--constants
  	constant PERIOD    : time := 10 ns;

	--Inputs
	SIGNAL CLK :  std_logic := '0';


    signal O, IO, I , T : std_logic;

     component IOBUF_F_16
          port(
            O  : out   std_logic;
            IO : inout std_logic;
            I  : in    std_logic;
            T  : in    std_logic
            );
        end component; 

begin

    tristate : IOBUF_F_16 port map(O, IO, I, T);

  process
  begin
    CLK <= '0';
    wait for PERIOD;
    CLK <= '1';
    wait for PERIOD;
  end process;
  
  simu: process
  begin
  
    I <= '0';
    T <= '1';
    IO <= 'Z';
    
    wait for PERIOD;
    -- TEST LECTURE
    T <= '1';
    IO <= '1';
    -- O passe à 1

    wait for PERIOD;
    
    T <= '0';
    I <= '0';
    IO <= 'Z';
    
    wait for PERIOD;
    
    I <= '1';
    -- IO passe à 1
    
    
    wait;
  
  end process;


end Behavioral;
