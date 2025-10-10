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
           Data_in : in STD_LOGIC_VECTOR (31 downto 0);
           Data_out : out STD_LOGIC_VECTOR (31 downto 0);
           Read : in STD_LOGIC;
           Write : in STD_LOGIC;
           User_addr : in STD_LOGIC_VECTOR (15 downto 0);
           
           -- SRAM
           Data_sram : inout STD_LOGIC_VECTOR(35 downto 0);
           Addr_sram : out STD_LOGIC_VECTOR (18 downto 0);
           nCKE : out STD_LOGIC;
           nRW : out STD_LOGIC
           );
end ctrl_sram;

architecture Behavioral of ctrl_sram is

    type ETATS is (ETAT_INIT, ETAT_IDLE, ETAT_WRITE, ETAT_READ);
    signal ETAT : ETATS := ETAT_INIT;
    
    signal Trig : std_logic;
    
    signal data_in_sig : std_logic_vector(35 downto 0);
    signal data_out_sig : std_logic_vector(35 downto 0);


    component IOBUF_F_16
      port(
        O  : out   std_logic;
        IO : inout std_logic;
        I  : in    std_logic;
        T  : in    std_logic
        );
    end component; 
 
begin

    gen_tristate: for i in 0 to 35 generate
        buff: IOBUF_F_16 port map(data_out_sig(i), Data_sram(i), data_in_sig(i), Trig);
    end generate gen_tristate;
    
    data_in_sig <= "0000" & data_in;
    data_out <= data_out_sig(31 downto 0);
    Addr_sram <= "000" & User_Addr;

    connection : process (CLK, Read, Write)
    begin
        if(CLK'event and CLK = '1') then
            case ETAT is
                when ETAT_INIT =>
                    ETAT <= ETAT_IDLE;
                when others =>
                    if (Read = '1') then
                        ETAT <= ETAT_READ;
                    elsif (Write = '1') then
                        ETAT <= ETAT_WRITE;
                    else 
                        ETAT <= ETAT_IDLE;
                    end if;         
            end case;        
        end if;   
    end process connection;

    act : process (ETAT)
    begin
        case ETAT is
            when ETAT_INIT =>
                nRW <= '0';
                nCKE <= '1';
                Trig <= '0';              
            when ETAT_IDLE =>
                nCKE <= '0';
                Trig <= '1';
            when ETAT_READ =>
                nRW <= '1';       
                nCKE <= '0';
                Trig <= '1';
            when ETAT_WRITE =>
                nRW <= '0';
                nCKE <= '0';
                Trig <= '0';
        end case;
    end process act;

end Behavioral;
