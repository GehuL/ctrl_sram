----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2025 15:13:52
-- Design Name: 
-- Module Name: ctrl_sram - Behavioral
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

entity ctrl_sram is
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
end ctrl_sram;

architecture Behavioral of ctrl_sram is

    type ETATS is (ETAT_INIT, ETAT_IDLE, ETAT_WRITE, ETAT_READ);
    signal ETAT : ETATS := ETAT_INIT;
    
    signal Trig : std_logic := '1';
    signal Trig_sig : std_logic := '1';
     -- Agit comme bascule D pour décaler d'un cycle d'horloge
    signal data_in_sig : std_logic_vector(31 downto 0);
    
    signal data_out_sig : std_logic_vector(31 downto 0);
    

    component IOBUF_F_16
      port(
        O  : out   std_logic;
        IO : inout std_logic;
        I  : in    std_logic;
        T  : in    std_logic
        );
    end component; 
 
begin

  --  gen_tristate: for i in 0 to 35 generate
  --      buff: IOBUF_F_16 port map(O => data_out_sig(i), IO => Data_sram(i), I => data_in_sig(i), T => Trig);
  -- end generate gen_tristate;
  
  nCKE <= '1' when ETAT = ETAT_IDLE else '0';
  Addr_sram <= "000" & User_Addr;
  Data_sram <= "0000" & data_in_sig when Trig_sig = '0' else (others => 'Z');
  Data_out <= Data_sram(31 downto 0); 
  Advld <= Burst when (ETAT = ETAT_READ or ETAT = ETAT_WRITE) else '0';
  
    connection : process (CLK, RESET)
    begin
        if (RESET = '1') then
            ETAT <= ETAT_INIT;
            nRW <= '1';
        elsif rising_edge(CLK) then
            case ETAT is
                when ETAT_INIT =>
                    ETAT <= ETAT_IDLE;
                    nRW <= '1';
                when others =>
                    if (Read = '1') then
                        ETAT <= ETAT_READ;
                        nRW <= '1';
                    elsif (Write = '1' or Burst = '1') then
                        ETAT <= ETAT_WRITE;
                        nRW <= '0';
                    else 
                        ETAT <= ETAT_IDLE;
                        nRW <= '1';
                end if;         
            end case;  
          
        end if;   
    end process connection;

    act : process (ETAT)
    begin
          case ETAT is
                when ETAT_INIT =>
                    Trig <= '1';
                when ETAT_IDLE =>
                    Trig <= '1';
                when ETAT_READ =>
                    Trig <= '1';
                when ETAT_WRITE =>
                    Trig <= '0';
                when others =>
            end case;
    end process act;
    
    data_flow: process(CLK, RESET)
    begin
      if RESET = '1' then
        data_in_sig <= (others => '0');
        Trig_sig <= '1';
      elsif rising_edge(CLK) then   
           data_in_sig <= Data_in;
           Trig_sig <= Trig;
      end if;
    end process;

end Behavioral;
