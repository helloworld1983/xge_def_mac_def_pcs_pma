-------------------------------------------------------------------------------
-- File       : ten_gig_eth_mac_0_support
-- Author     : Xilinx Inc.
-------------------------------------------------------------------------------
-- Description: This is the Support level of the 10 Gigabit Ethernet MAC.
--              If XGMII is selected, it includes the transmit clocking
--              resources. If Internal interface is selected, it is an empty
--              layer of hierarchy.
-------------------------------------------------------------------------------
-- (c) Copyright 2001-2014 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ten_gig_eth_mac_0_support is
  port(
    clk_156                            : in  std_logic;
    clk_locked                         : in  std_logic;
    reset                              : in std_logic;
    tx_reset                           : in  std_logic;
    rx_reset                           : in  std_logic;
    tx_axis_aresetn                    : in std_logic;
    tx_axis_tdata                      : in std_logic_vector(63 downto 0);
    tx_axis_tkeep                      : in std_logic_vector(7 downto 0);
    tx_axis_tready                     : out std_logic;
    tx_axis_tvalid                     : in std_logic;
    tx_axis_tlast                      : in std_logic;
    rx_axis_aresetn                    : in std_logic;
    rx_axis_tdata                      : out std_logic_vector(63 downto 0);
    rx_axis_tkeep                      : out std_logic_vector(7 downto 0);
    rx_axis_tvalid                     : out std_logic;
    rx_axis_tuser                      : out std_logic;
    rx_axis_tlast                      : out std_logic;
    xgmii_txd                          : out std_logic_vector(63 downto 0); -- Transmitted data
    xgmii_txc                          : out std_logic_vector(7 downto 0); -- Transmitted control
    xgmii_rxd                          : in  std_logic_vector(63 downto 0); -- Received data
    xgmii_rxc                          : in  std_logic_vector(7 downto 0));  -- received control
end ten_gig_eth_mac_0_support;


architecture rtl of ten_gig_eth_mac_0_support is
component ten_gig_eth_mac_0
  port(
    reset                              : in std_logic;
    tx_axis_aresetn                    : in std_logic;
    tx_axis_tdata                      : in std_logic_vector(63 downto 0);
    tx_axis_tkeep                      : in std_logic_vector(7 downto 0);
    tx_axis_tready                     : out std_logic;
    tx_axis_tvalid                     : in std_logic;
    tx_axis_tlast                      : in std_logic;
    tx_axis_tuser                      : in std_logic_vector(0 downto 0);
    tx_ifg_delay                       : in std_logic_vector(7 downto 0);
    tx_statistics_vector               : out std_logic_vector(25 downto 0);
    tx_statistics_valid                : out std_logic;
    pause_val                          : in  std_logic_vector(15 downto 0);
    pause_req                          : in  std_logic;
    rx_axis_aresetn                    : in std_logic;
    rx_axis_tdata                      : out std_logic_vector(63 downto 0);
    rx_axis_tkeep                      : out std_logic_vector(7 downto 0);
    rx_axis_tvalid                     : out std_logic;
    rx_axis_tuser                      : out std_logic;
    rx_axis_tlast                      : out std_logic;
    rx_statistics_vector               : out std_logic_vector(29 downto 0);
    rx_statistics_valid                : out std_logic;
    tx_configuration_vector            : in std_logic_vector(79 downto 0);
    rx_configuration_vector            : in std_logic_vector(79 downto 0);
    status_vector                      : out std_logic_vector(1 downto 0);

    tx_clk0                            : in  std_logic;
    tx_dcm_locked                      : in  std_logic;
    xgmii_txd                          : out std_logic_vector(63 downto 0); -- Transmitted data
    xgmii_txc                          : out std_logic_vector(7 downto 0); -- Transmitted control
    rx_clk0                            : in std_logic;
    rx_dcm_locked                      : in std_logic;
    xgmii_rxd                          : in  std_logic_vector(63 downto 0); -- Received data
    xgmii_rxc                          : in  std_logic_vector(7 downto 0));  -- received control
end component;

component button_filter
    port (
        clk           : in  std_logic;
        in_pulse      : in  std_logic := '0';
        out_pulse     : out std_logic := '0'
    );
end component;

   signal rx_configuration_vector      : std_logic_vector(79 downto 0);
   signal tx_configuration_vector      : std_logic_vector(79 downto 0);

--   signal tx_reset                     : std_logic;
   signal tx_reset_int                 : std_logic;
   signal tx_enable                    : std_logic;
   signal tx_vlan_enable               : std_logic := '0';
   signal tx_fcs_enable                : std_logic := '0';
   signal tx_jumbo_enable              : std_logic := '0';
   signal tx_fc_enable                 : std_logic := '0';
   signal tx_custom_preamble           : std_logic := '0';
   signal tx_ifg_adjust                : std_logic := '0';
   signal tx_wan_enable                : std_logic := '0';
   signal tx_dic_enable                : std_logic := '0';
   signal tx_max_frame_enable          : std_logic := '0';
   signal tx_max_frame_length          : std_logic_vector(14 downto 0) := (OTHERS => '0');
   signal tx_pause_addr                : std_logic_vector(47 downto 0) := x"000000000000";

--   signal rx_reset                     : std_logic;
   signal rx_reset_int                 : std_logic;
   signal rx_enable                    : std_logic;
   signal rx_vlan_enable               : std_logic := '0';
   signal rx_fcs_enable                : std_logic := '0';
   signal rx_jumbo_enable              : std_logic := '0';
   signal rx_fc_enable                 : std_logic := '0';
   signal rx_custom_preamble           : std_logic := '0';
   signal rx_len_type_chk_disable      : std_logic := '0';
   signal rx_control_len_chk_dis       : std_logic := '0';
   signal rx_rs_inhibit                : std_logic := '0';
   signal rx_max_frame_enable          : std_logic := '0';
   signal rx_max_frame_length          : std_logic_vector(14 downto 0) := (OTHERS => '0');
   signal rx_pause_addr                : std_logic_vector(47 downto 0) := x"000000000000";

begin

  ten_gig_eth_mac_core_i : ten_gig_eth_mac_0
  port map (
    reset                              => reset,
    tx_axis_aresetn                    => tx_axis_aresetn,
    tx_axis_tdata                      => tx_axis_tdata,
    tx_axis_tvalid                     => tx_axis_tvalid,
    tx_axis_tlast                      => tx_axis_tlast,
    tx_axis_tuser                      => (OTHERS => '0'),
    tx_ifg_delay                       => x"00",
    tx_axis_tkeep                      => tx_axis_tkeep,
    tx_axis_tready                     => tx_axis_tready,
    tx_statistics_vector               => open,
    tx_statistics_valid                => open,
    pause_val                          => x"0000",
    pause_req                          => '0',
    rx_axis_aresetn                    => rx_axis_aresetn,
    rx_axis_tdata                      => rx_axis_tdata,
    rx_axis_tvalid                     => rx_axis_tvalid,
    rx_axis_tuser                      => rx_axis_tuser,
    rx_axis_tlast                      => rx_axis_tlast,
    rx_axis_tkeep                      => rx_axis_tkeep,
    rx_statistics_vector               => open,
    rx_statistics_valid                => open,
    tx_configuration_vector            => tx_configuration_vector,
    rx_configuration_vector            => rx_configuration_vector,
    status_vector                      => open,

    tx_clk0                            => clk_156,
    tx_dcm_locked                      => clk_locked,
    xgmii_txd                          => xgmii_txd,
    xgmii_txc                          => xgmii_txc,
    rx_clk0                            => clk_156,
    rx_dcm_locked                      => clk_locked,
    xgmii_rxd                          => xgmii_rxd,
    xgmii_rxc                          => xgmii_rxc);


   rx_configuration_vector             <= rx_pause_addr & 
                                          '0' &  rx_max_frame_length & 
                                          '0' &  rx_max_frame_enable & 
                                          "000" &  rx_rs_inhibit &  
                                          rx_control_len_chk_dis & 
                                          rx_len_type_chk_disable & 
                                          rx_custom_preamble & 
                                          '0' &  rx_fc_enable & 
                                          rx_jumbo_enable & 
                                          rx_fcs_enable & 
                                          rx_vlan_enable & 
                                          rx_enable & 
                                          rx_reset;

   tx_configuration_vector             <= tx_pause_addr & 
                                          '0' &  tx_max_frame_length & 
                                          '0' &  tx_max_frame_enable & 
                                          "000" &  tx_dic_enable & 
                                          tx_wan_enable &  tx_ifg_adjust & 
                                          tx_custom_preamble &  
                                          '0' &  tx_fc_enable & 
                                          tx_jumbo_enable & 
                                          tx_fcs_enable & 
                                          tx_vlan_enable & 
                                          tx_enable & 
                                          tx_reset;

   tx_rst_en: button_filter
    port map(
        clk                            => clk_156,
        in_pulse                       => tx_reset,
        out_pulse                      => tx_reset_int
    );

   tx_enable                          <= clk_locked and not tx_reset_int;

   rx_rst_en: button_filter
    port map(
        clk                            => clk_156,
        in_pulse                       => rx_reset,
        out_pulse                      => rx_reset_int
    );

   rx_enable                          <= clk_locked and not rx_reset_int;

end rtl;


