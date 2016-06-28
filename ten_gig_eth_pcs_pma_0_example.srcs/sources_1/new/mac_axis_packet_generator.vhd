----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2016 05:13:16 PM
-- Design Name: 
-- Module Name: mac_axis_packet_generator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac_axis_packet_generator is
    port( 
--        tx_clk          : in  std_logic;
--        rx_clk          : in  std_logic;
        clk_156         : in  std_logic;
        eth_send        : in  std_logic;
        src_addr        : in  std_logic_vector(47 downto 0);
        dest_addr       : in  std_logic_vector(47 downto 0);
        tx_axis_aresetn : in  std_logic;
        tx_axis_tdata   : out std_logic_vector(63 downto 0);
        tx_axis_tkeep   : out std_logic_vector(7 downto 0);
        tx_axis_tvalid  : out std_logic;
        tx_axis_tlast   : out std_logic;
        tx_axis_tready  : in  std_logic;
        rx_axis_aresetn : in  std_logic;
        rx_axis_tdata   : in  std_logic_vector(63 downto 0);
        rx_axis_tkeep   : in  std_logic_vector(7 downto 0);
        rx_axis_tvalid  : in  std_logic;
        rx_axis_tlast   : in  std_logic;
        rx_axis_tready  : out std_logic
    );
end mac_axis_packet_generator;

architecture Behavioral of mac_axis_packet_generator is

signal xgmii_txd_int    : std_logic_vector(63 downto 0);
signal xgmii_txc_int    : std_logic_vector(7 downto 0);
signal xgmii_dvalid     : std_logic;
signal xgmii_dlast      : std_logic;

begin
    tx_dispatch: process(clk_156)
        variable eth_send_st          : boolean := false;
        variable count                : integer := 0;
        variable byte_0               : integer := 02;
        variable byte_1               : integer := 03;
        variable byte_2               : integer := 04;
        variable byte_3               : integer := 05;
        variable byte_4               : integer := 06;
        variable byte_5               : integer := 07;
        variable byte_6               : integer := 00;
        variable byte_7               : integer := 01;
    begin
        if (clk_156'event AND clk_156 = '1') then
            if (eth_send = '1' AND eth_send_st = false) then
                eth_send_st := true;
                count       := 0;
            elsif (eth_send_st = true AND tx_axis_tready = '1') then
                if (count = 0) then
                    xgmii_txd_int( 7 downto  0) <= dest_addr(47 downto 40);
                    xgmii_txd_int(15 downto  8) <= dest_addr(39 downto 32);
                    xgmii_txd_int(23 downto 16) <= dest_addr(31 downto 24);
                    xgmii_txd_int(31 downto 24) <= dest_addr(23 downto 16);
                    xgmii_txd_int(39 downto 32) <= dest_addr(15 downto  8);
                    xgmii_txd_int(47 downto 40) <= dest_addr( 7 downto  0);
                    xgmii_txd_int(55 downto 48) <= src_addr(47 downto 40);
                    xgmii_txd_int(63 downto 56) <= src_addr(39 downto 32);
                    xgmii_txc_int               <= x"FF";
    
                    xgmii_dvalid                <= '1';
                elsif (count = 8) then
                    xgmii_txd_int( 7 downto  0) <= src_addr(31 downto 24);
                    xgmii_txd_int(15 downto  8) <= src_addr(23 downto 16);
                    xgmii_txd_int(23 downto 16) <= src_addr(15 downto  8);
                    xgmii_txd_int(31 downto 24) <= src_addr( 7 downto  0);
                    xgmii_txd_int(39 downto 32) <= x"00";
                    xgmii_txd_int(47 downto 40) <= x"3A";
                    xgmii_txd_int(55 downto 48) <= std_logic_vector(to_unsigned(byte_6, 8));
                    xgmii_txd_int(63 downto 56) <= std_logic_vector(to_unsigned(byte_7, 8));
                    xgmii_txc_int               <= x"FF";

                    xgmii_dvalid            <= '1';

                    byte_6                  := byte_6 + 8;
                    byte_7                  := byte_7 + 8;
                elsif (count < 80 - 8) then
                    xgmii_txd_int( 7 downto  0) <= std_logic_vector(to_unsigned(byte_0, 8));
                    xgmii_txd_int(15 downto  8) <= std_logic_vector(to_unsigned(byte_1, 8));
                    xgmii_txd_int(23 downto 16) <= std_logic_vector(to_unsigned(byte_2, 8));
                    xgmii_txd_int(31 downto 24) <= std_logic_vector(to_unsigned(byte_3, 8));
                    xgmii_txd_int(39 downto 32) <= std_logic_vector(to_unsigned(byte_4, 8));
                    xgmii_txd_int(47 downto 40) <= std_logic_vector(to_unsigned(byte_5, 8));
                    xgmii_txd_int(55 downto 48) <= std_logic_vector(to_unsigned(byte_6, 8));
                    xgmii_txd_int(63 downto 56) <= std_logic_vector(to_unsigned(byte_7, 8));
                    xgmii_txc_int               <= x"FF";

                    xgmii_dvalid            <= '1';

                    byte_0                  := byte_0 + 8;
                    byte_1                  := byte_1 + 8;
                    byte_2                  := byte_2 + 8;
                    byte_3                  := byte_3 + 8;
                    byte_4                  := byte_4 + 8;
                    byte_5                  := byte_5 + 8;
                    byte_6                  := byte_6 + 8;
                    byte_7                  := byte_7 + 8;
                else
                    xgmii_txd_int           <= x"0000000000000000";
                    xgmii_txc_int           <= x"00";

                    xgmii_dvalid            <= '0';

                    byte_0                  := 02;
                    byte_1                  := 03;
                    byte_2                  := 04;
                    byte_3                  := 05;
                    byte_4                  := 06;
                    byte_5                  := 07;
                    byte_6                  := 00;
                    byte_7                  := 01;
                end if;

                if (count = 80 - 8 - 8) then
                    eth_send_st             := false;
                    count                   := 0;

                    xgmii_dlast             <= '1';
                elsif (count < 80 - 8 - 8 and tx_axis_tready = '1') then
                    count                   := count + 8;

                    xgmii_dlast             <= '0';
                end if;
            elsif (eth_send_st = true and tx_axis_tready = '0') then
                xgmii_txd_int               <= xgmii_txd_int;
                xgmii_txc_int               <= xgmii_txc_int;

                xgmii_dvalid                <= '1';
            else
                eth_send_st := false;
                count       := 0;

                xgmii_txd_int <= x"0000000000000000";
                xgmii_txc_int <= x"00";

                xgmii_dvalid  <= '0';
            end if;
        end if;
    end process;

tx_axis_tdata  <= xgmii_txd_int;
tx_axis_tkeep  <= xgmii_txc_int;
tx_axis_tvalid <= xgmii_dvalid;
tx_axis_tlast  <= xgmii_dlast;
end Behavioral;
