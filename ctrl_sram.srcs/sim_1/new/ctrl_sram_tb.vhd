----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2025 08:16:46
-- Design Name: 
-- Module Name: ctrl_sram_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl_sram_tb is
--  Port ( );
end ctrl_sram_tb;

architecture Behavioral of ctrl_sram_tb is

component ctrl_sram is
    Port ( 
           -- USER
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           Data_in : in STD_LOGIC_VECTOR (31 downto 0);
           Data_out : out STD_LOGIC_VECTOR (31 downto 0);
           Read : in STD_LOGIC;
           Write : in STD_LOGIC;
           User_addr : in STD_LOGIC_VECTOR (15 downto 0);
           Burst : in STD_LOGIC;
           -- SRAM
           Data_sram : inout STD_LOGIC_VECTOR(35 downto 0);
           Addr_sram : out STD_LOGIC_VECTOR (18 downto 0);
           nCKE : out STD_LOGIC;
           nRW : out STD_LOGIC;
           Advld : out STD_LOGIC
           );
end component;

component mt55l512y36f is
    generic (
      -- Constant parameters
      addr_bits : integer := 19;
      data_bits : integer := 36;

      -- Timing parameters for -10 (100 Mhz)
      tKHKH : time := 10.0 ns;
      tKHKL : time := 2.5 ns;
      tKLKH : time := 2.5 ns;
      tKHQV : time := 5.0 ns;
      tAVKH : time := 2.0 ns;
      tEVKH : time := 2.0 ns;
      tCVKH : time := 2.0 ns;
      tDVKH : time := 2.0 ns;
      tKHAX : time := 0.5 ns;
      tKHEX : time := 0.5 ns;
      tKHCX : time := 0.5 ns;
      tKHDX : time := 0.5 ns
      );

    -- Port Declarations
    port (
      Dq    : inout std_logic_vector (data_bits - 1 downto 0);  -- Data I/O
      Addr  : in    std_logic_vector (addr_bits - 1 downto 0);  -- Address
      Lbo_n : in    std_logic;                                  -- Burst Mode
      Clk   : in    std_logic;                                  -- Clk
      Cke_n : in    std_logic;                                  -- Cke#
      Ld_n  : in    std_logic;                                  -- Adv/Ld#
      Bwa_n : in    std_logic;                                  -- Bwa#
      Bwb_n : in    std_logic;                                  -- BWb#
      Bwc_n : in    std_logic;                                  -- Bwc#
      Bwd_n : in    std_logic;                                  -- BWd#
      Rw_n  : in    std_logic;                                  -- RW#
      Oe_n  : in    std_logic;                                  -- OE#
      Ce_n  : in    std_logic;                                  -- CE#
      Ce2_n : in    std_logic;                                  -- CE2#
      Ce2   : in    std_logic;                                  -- CE2
      Zz    : in    std_logic                                   -- Snooze Mode
      );
  end component;
    
	--constants
  	constant TCLKH    : time := 5 ns;
  	constant TCLKL    : time := 5 ns;

	--Inputs
	SIGNAL CLKO_SRAM :  std_logic := '0';
	
	-- USER
    signal data_in : std_logic_vector(31 downto 0);
    signal data_out : std_logic_vector(31 downto 0);
    signal user_addr : std_logic_vector(15 downto 0);
    signal read : std_logic;
    signal write : std_logic;
    signal Burst : std_logic;
    signal RESET : std_logic;
    
    -- SRAM
    signal Data_sram : STD_LOGIC_VECTOR(35 downto 0);
    signal Addr_sram : STD_LOGIC_VECTOR (18 downto 0);
    signal nCKE : STD_LOGIC;
    signal nRW : STD_LOGIC;
    SIGNAL nADVLD :  std_logic := '0';
	SIGNAL nOE:  std_logic := '0';
	SIGNAL nCE:  std_logic := '0';
	SIGNAL nCE2:  std_logic := '0';
	SIGNAL CE2:  std_logic := '0';

begin
  process
  begin
    CLKO_SRAM <= '0';
    wait for TCLKL;
    CLKO_SRAM <= '1';
    wait for TCLKH;
  end process;
  
  ctrl : ctrl_sram port map (CLK => CLKO_SRAM, RESET => reset, Data_in => data_in, Data_out => data_out, 
                            Read => read, Write => write, User_addr => user_addr, Burst => Burst,
                            Data_sram => data_sram, Addr_sram => addr_sram, nCKE => nCKE, nRW => nRW, Advld => nADVLD);

	-- Instantiate the Unit Under Test (UUT)
  SRAM1 : mt55l512y36f port map
    (Dq => data_sram, Addr => addr_sram, Lbo_n => '0', Clk => CLKO_SRAM, Cke_n => nCKE, Ld_n => nADVLD, Bwa_n => '0',
     Bwb_n => '0', Bwc_n => '0', Bwd_n => '0', Rw_n => nRW, Oe_n => nOE, Ce_n => nCE, Ce2_n => nCE2, Ce2 => CE2, Zz => '0');

    tb : PROCESS
        BEGIN
        
        -- INITIALISATION
        RESET <= '1';
        nOE		<= '0';
        nCE 		<= '0';
        nCE2 		<= '0';
        CE2 		<= '1';
        
        Data_in <= (others => '0');
        user_addr <= (others => '0');
        
        read <= '0';
        write <= '0';
        Burst <= '0';
        
        wait until CLKO_SRAM'event and CLKO_SRAM='1';
        wait for 2 ns;
        
        wait for 5*(TCLKL+TCLKH);
       
        RESET <= '0';
	   
	   -- Attend l'initialisation de la SRAM
	    wait for 4*(TCLKL+TCLKH);
	    
        -- ECRITURE 
        write <= '1';
        
        wait for 1*(TCLKL+TCLKH);
        
        for i in 0 to 8 loop
            user_addr <= std_logic_vector(to_unsigned(i, user_addr'length));
            data_in <= std_logic_vector(to_unsigned(i, data_in'length));
            wait for 1*(TCLKL+TCLKH);
        end loop;
      
        -- IDLE
        write <= '0';
                
       -- LECTURE ADDR=0 EXPECTED VALUE=FFFFFFF
        read <= '1';
       
        wait for 1*(TCLKL+TCLKH);

        for i in 0 to 8 loop
            user_addr <= std_logic_vector(to_unsigned(i, user_addr'length));
            assert(unsigned(data_out) = i) report "data_out should be equald to i";
            wait for 1*(TCLKL+TCLKH);
        end loop;

        wait for 1*(TCLKL+TCLKH);
        
        read <= '0';
        
        wait for 1*(TCLKL+TCLKH);
        
        -- ECRITURE EN MODE BURST (START ADDR=0x8 TO 0XB)
        write <= '1';
        
        wait for 2*(TCLKL+TCLKH);
        
        Burst <= '1';
        
        for i in 0 to 3 loop
            data_in <= std_logic_vector(to_unsigned(i, data_in'length));
            wait for 1*(TCLKL+TCLKH);
        end loop;
        
        -- LECTURE EN MODE BURST (START ADDR=0x08 TO 0X0B)
        Burst <= '0'; -- On reset l'adresse  
        write <= '0';
        read <= '1';
        
        wait for 2*(TCLKL+TCLKH);
        
        Burst <= '1';
        
        wait for 10*(TCLKL+TCLKH);
        
        -- RESET
        read <= '0';
        write <= '0';
        RESET <= '1';
        
        wait;
        
    end process;


end Behavioral;
