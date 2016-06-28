----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2016 11:16:08 PM
-- Design Name: 
-- Module Name: ten_gig_eth_pcs_pma_0_top - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity ten_gig_eth_pcs_pma_0_top is
    port ( clk_in_p : in STD_LOGIC;
           clk_in_n : in STD_LOGIC;
           refclk_p : in STD_LOGIC;
           refclk_n : in STD_LOGIC;
           txp : out STD_LOGIC;
           txn : out STD_LOGIC;
           rxp : in STD_LOGIC;
           rxn : in STD_LOGIC);
end ten_gig_eth_pcs_pma_0_top;

architecture Behavioral of ten_gig_eth_pcs_pma_0_top is

component IBUFGDS is
    port (
      I                         : in  std_logic;
      IB                        : in  std_logic;
      O                         : out std_logic
    );
end component;

component vio_0 is
    port (
      clk                       : in  std_logic;
      probe_out0                : out std_logic_vector(3 downto 0);
      probe_out1                : out std_logic_vector(2 downto 0);
      probe_out2                : out std_logic_vector(47 downto 0);
      probe_out3                : out std_logic_vector(47 downto 0);
      probe_in0                 : in  std_logic_vector(7 downto 0)
    );
end component;

component button_filter
    port (
        clk           : in  std_logic;
        in_pulse      : in  std_logic := '0';
        out_pulse     : out std_logic := '0'
    );
end component;

component ten_gig_eth_pcs_pma_0_example_design is
    port (
      refclk_p                  : in  std_logic;
      refclk_n                  : in  std_logic;
      dclk                      : in  std_logic;
      coreclk_out               : out std_logic;
      reset                     : in  std_logic;
      sim_speedup_control       : in  std_logic := '0';
      xgmii_txd                 : in  std_logic_vector(63 downto 0);
      xgmii_txc                 : in  std_logic_vector(7 downto 0);
      xgmii_rxd                 : out std_logic_vector(63 downto 0) := x"0000000000000000";
      xgmii_rxc                 : out std_logic_vector(7 downto 0) := x"00";
      xgmii_rx_clk              : out std_logic;
      txp                       : out std_logic;
      txn                       : out std_logic;
      rxp                       : in  std_logic;
      rxn                       : in  std_logic;
      pma_loopback              : in  std_logic;
      pma_reset                 : in  std_logic;
      global_tx_disable         : in  std_logic;
      pcs_loopback              : in  std_logic;
      pcs_reset                 : in  std_logic;
      test_patt_a_b             : in  std_logic_vector(57 downto 0);
      data_patt_sel             : in  std_logic;
      test_patt_sel             : in  std_logic;
      rx_test_patt_en           : in  std_logic;
      tx_test_patt_en           : in  std_logic;
      prbs31_tx_en              : in  std_logic;
      prbs31_rx_en              : in  std_logic;
      set_pma_link_status       : in  std_logic;
      set_pcs_link_status       : in  std_logic;
      clear_pcs_status2         : in  std_logic;
      clear_test_patt_err_count : in  std_logic;

      pma_link_status           : out std_logic;
      rx_sig_det                : out std_logic;
      pcs_rx_link_status        : out std_logic;
      pcs_rx_locked             : out std_logic;
      pcs_hiber                 : out std_logic;
      teng_pcs_rx_link_status   : out std_logic;
      pcs_err_block_count       : out std_logic_vector(7 downto 0);
      pcs_ber_count             : out std_logic_vector(5 downto 0);
      pcs_rx_hiber_lh           : out std_logic;
      pcs_rx_locked_ll          : out std_logic;
      pcs_test_patt_err_count   : out std_logic_vector(15 downto 0);
      core_status               : out std_logic_vector(7 downto 0);
      resetdone                 : out std_logic;
      signal_detect             : in  std_logic;
      tx_fault                  : in  std_logic;
      tx_disable                : out std_logic);
end component;

component ten_gig_eth_mac_0_support is
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
end component;

component mac_axis_packet_generator is
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
end component;

component mac_packet_generator is
    port (
        clk_156                       : in  std_logic;
        eth_send                      : in  std_logic;
        src_addr                      : in  std_logic_vector(47 downto 0);
        dest_addr                     : in  std_logic_vector(47 downto 0);
        oload_crc                     : in  std_logic_vector(31 downto 0);
        xgmii_txd                     : out std_logic_vector(63 downto 0);
        xgmii_txc                     : out std_logic_vector(7 downto 0)
    );
end component;

signal clk_100                  : std_logic;
signal clk_156                  : std_logic;
signal areset                   : std_logic;
signal aresetn                  : std_logic;

signal xgmii_txd                : std_logic_vector(63 downto 0);
signal xgmii_txc                : std_logic_vector(7 downto 0);
signal xgmii_rxd                : std_logic_vector(63 downto 0);
signal xgmii_rxc                : std_logic_vector(7 downto 0);
signal cfg_pma_loopback         : std_logic;
signal cfg_pma_reset            : std_logic;
signal cfg_tx_disable           : std_logic;
signal cfg_pcs_loopback         : std_logic;
signal cfg_pcs_reset            : std_logic;

signal cfg_mac_tx_reset         : std_logic;
signal cfg_mac_rx_reset         : std_logic;

signal sts_pma_link_status      : std_logic;
signal sts_sig_detect           : std_logic;
signal sts_pcs_link_status      : std_logic;
signal sts_pcs_lock             : std_logic;
signal sts_pcs_hiber            : std_logic;
signal sts_xpcs_rx_link_status  : std_logic;
signal core_status              : std_logic_vector(7 downto 0);
signal sts_pcs_rx_lock          : std_logic;
signal sts_pcs_pma_lock         : std_logic;
signal signal_detect_or_const   : std_logic;
signal tx_fault_or_const        : std_logic;
signal tx_disable_or_const      : std_logic;

signal signal_detect            : std_logic;
signal tx_fault                 : std_logic;
signal tx_disable               : std_logic;

constant copper                 : boolean := true;    

signal eth_send                 : std_logic;
signal cfg_eth_send             : std_logic;
signal dest_addr                : std_logic_vector(47 downto 0);
signal src_addr                 : std_logic_vector(47 downto 0);
signal ovload_crc               : std_logic_vector(31 downto 0);

signal mac_tx_tdata             : std_logic_vector(63 downto 0);
signal mac_tx_tkeep             : std_logic_vector(7 downto 0);
signal mac_tx_tvalid            : std_logic;
signal mac_tx_tlast             : std_logic;
signal mac_tx_ready             : std_logic;
signal mac_rx_tdata             : std_logic_vector(63 downto 0);
signal mac_rx_tkeep             : std_logic_vector(7 downto 0);
signal mac_rx_tvalid            : std_logic;
signal mac_rx_tlast             : std_logic;

attribute mark_debug            : string;
attribute mark_debug of eth_send : signal is "true";
attribute mark_debug of xgmii_txd : signal is "true";
attribute mark_debug of xgmii_txc : signal is "true";
attribute mark_debug of xgmii_rxd : signal is "true";
attribute mark_debug of xgmii_rxc : signal is "true";
attribute mark_debug of  mac_tx_tdata  : signal is "true";
attribute mark_debug of  mac_tx_tkeep  : signal is "true";
attribute mark_debug of  mac_tx_tvalid : signal is "true";
attribute mark_debug of  mac_tx_tlast  : signal is "true";
attribute mark_debug of  mac_tx_ready  : signal is "true";

begin

    clk_i: IBUFGDS
        port map(
            O                    => clk_100,
            I                    => clk_in_p,
            IB                   => clk_in_n
        );

    pcs_pma_0: ten_gig_eth_pcs_pma_0_example_design
        port map(
            refclk_p             => refclk_p,
            refclk_n             => refclk_n,
            dclk                 => clk_100,         -- MANAGEMENT CLOCK
            coreclk_out          => clk_156,         -- RESET LOGIC DOMAIN
                                                     -- MIGHT HAVE TO EXPOSE TXUSRCLK2_OUT
            reset                => areset,          -- ASYNCHRONOUS RESET, RESET MANAGEMENT REGISTERS
            sim_speedup_control  => '0',

            xgmii_txd            => xgmii_txd,
            xgmii_txc            => xgmii_txc,
            xgmii_rxd            => xgmii_rxd,
            xgmii_rxc            => xgmii_rxc,
            xgmii_rx_clk         => open,            -- DOUBLE DATA REGISTER FOR 32-BIT DDR XGMII
            txp                  => txp,
            txn                  => txn,
            rxp                  => rxp,
            rxn                  => rxn,
            pma_loopback         => cfg_pma_loopback,-- CONFIGURATION_VECTOR(0), ASYNCHRONOUS
            pma_reset            => cfg_pma_reset,   -- CONFIGURATION_VECTOR(15), TX CLOCK SOURCE
            global_tx_disable    => cfg_tx_disable,  -- CONFIGURATION_VECTOR(16), ASYNCHRONOUS
            pcs_loopback         => cfg_pcs_loopback,-- CONFIGURATION_VECTOR(110), TX CLOCK SOURCE
            pcs_reset            => cfg_pcs_reset,   -- CONFIGURATION_VECTOR(111), TX CLOCK SOURCE
            test_patt_a_b        => b"0000010011011111110001001001001000000100100101101001001000",
            data_patt_sel        => '0',             -- 1 ZEROS PATTERN; 0 LOW-FREQUENCY DATA PATTERN, CONFIGURATION_VECTOR(240), TX CLOCK SOURCE
            test_patt_sel        => '0',             -- 1 SQUARE WAVE; 0 PSEUDO-RANDOM, CONFIGURATION_VECTOR(241), TX CLOCK SOURCE
            rx_test_patt_en      => '0',             -- TEST PATTERN CHECK, CONFIGURATION_VECTOR(242), TX CLOCK SOURCE
            tx_test_patt_en      => '0',             -- TEST PATTERN GENERATION, CONFIGURATION_VECTOR(243), TX CLOCK SOURCE
            prbs31_tx_en         => '0',             -- PRBS31, CONFIGURATION_VECTOR(244), TX CLOCK SOURCE
            prbs31_rx_en         => '0',             -- PRBS31, CONFIGURATION_VECTOR(245), TX CLOCK SOURCE
            set_pma_link_status  => '1',             -- RECEIVE LINK UP, DEFAULT '1', CONFIGURATION_VECTOR(512), TX CLOCK SOURCE
            set_pcs_link_status  => '1',             -- RECEIVE LINK UP, NO DEFAULT, CONFIGURATION_VECTOR(516), TX CLOCK SOURCE
            clear_pcs_status2    => '0',             -- 10GBASE-R STATUS 2, CONFIGURATION_VECTOR(518), TX CLOCK SOURCE
            clear_test_patt_err_count => '0',        -- 10GBASE-R TEST PATTERN ERROR COUNTER, CONFIGURATION_VECTOR(519), TX CLOCK SOURCE
            pma_link_status      => sts_pma_link_status, -- PMA/PMD LINK_STATUS, CONFIGURATION_VECTOR(18), TX CLOCK SOURCE
            rx_sig_det           => sts_sig_detect,  -- GLOBAL PMD RECEIVE, CONFIGURATION_VECTOR(48), TX CLOCK SOURCE
            pcs_rx_link_status   => sts_pcs_link_status, -- PCS RX LINK_STATUS, '1' LINK UP, CONFIGURATION_VECTOR(226), TX CLOCK SOURCE
            pcs_rx_locked        => sts_pcs_rx_lock, -- 10-GBASE-R PCS RX BLOCK LOCK SYNCHRONISED, '1' SYNCHRONISED, CONFIGURATION_VECTOR(256), TX CLOCK SOURCE
            pcs_hiber            => sts_pcs_hiber,   -- 10-GBASE-R PCS RX HIGH BIT-ERROR RATE, '1' HIGH ERROR, CONFIGURATION_VECTOR(257), TX CLOCK SOURCE
            teng_pcs_rx_link_status => sts_xpcs_rx_link_status, -- 10-GBASE-R PCS LINK_STATUS, '1' ALIGNED, CONFIGURATION_VECTOR(268), TX CLOCK SOURCE
            pcs_err_block_count  => open,            -- PCS ERROR BLOCKS COUNTER, CONFIGURATION_VECTOR(279:272), TX CLOCK SOURCE
            pcs_rx_hiber_lh      => open,            -- PCS RX HIGH BIT-ERROR RATE LATCHING HIGH, CONFIGURATION_VECTOR(286), TX CLOCK SOURCE
            pcs_rx_locked_ll     => open,            -- PCS LOCKED LATCHING LOW, CONFIGURATION_VECTOR(287), TX CLOCK SOURCE
            pcs_test_patt_err_count => open,         -- PMA/PMD LINK_STATUS, CONFIGURATION_VECTOR(303:288), TX CLOCK SOURCE
            core_status          => core_status,     -- 10GBASE-R BITS[0] PCS BLOCK LOCK; BITS[7:1] RESERVED
            resetdone            => sts_pcs_pma_lock, -- BLOCK READY
            signal_detect        => signal_detect_or_const,
            tx_fault             => tx_fault_or_const,
            tx_disable           => tx_disable_or_const

--           qplloutclk_out       => open,
--           qplloutrefclk_out    => open,
--           qplllock_out         => pcs_qplllock,
--           txusrclk_out         => open,
--           txusrclk2_out        => clk_156,         -- TX DATAPATH CLOCK
--           gttxreset_out        => gtx_reset,       -- TX RESET, SYNCHRONOUS WITH CORECLK
--           gtrxreset_out        => open,            -- RX RESET, SYNCHRONOUS WITH CORECLK
--           txuserrdy_out        => gtx_lock,        -- TX LOCK (READY), SYNCHRONOUS WITH CORECLK
--           rxrecclk_out         => open,            -- SYNCHRONOUS WITH TXUSRCLK2 IF RX ELASTIC BUFFER IS PRESENT
--           pma_pmd_type         => "101",
        );

    ctrl_vio: vio_0
        port map(
            clk                   => clk_100,
            probe_out0(0)         => areset,
            probe_out0(1)         => cfg_pma_reset,
            probe_out0(2)         => cfg_pcs_reset,
            probe_out0(3)         => cfg_eth_send,
            probe_out1(0)         => cfg_pma_loopback,
            probe_out1(1)         => cfg_pcs_loopback,
            probe_out1(2)         => cfg_tx_disable,
            probe_out2            => src_addr,
            probe_out3            => dest_addr,
            probe_in0(0)          => sts_pma_link_status,
            probe_in0(1)          => sts_pcs_link_status,
            probe_in0(2)          => sts_xpcs_rx_link_status,
            probe_in0(3)          => sts_pcs_pma_lock,
            probe_in0(4)          => sts_sig_detect,
            probe_in0(5)          => sts_pcs_lock,
            probe_in0(6)          => sts_pcs_rx_lock,
            probe_in0(7)          => sts_pcs_hiber
        );

    copper_det: if copper = true generate
        signal_detect_or_const        <= '1';
        tx_fault_or_const             <= '0';
        tx_disable_or_const           <= 'Z';
    end generate;

    fiber_det: if copper = false generate
        signal_detect_or_const        <= signal_detect;
        tx_fault_or_const             <= tx_fault;
        tx_disable_or_const           <= tx_disable;
    end generate;

    sts_pcs_lock                  <= core_status(0);

--    mac_0: mac_packet_generator
--        port map(
--            clk_156               => clk_156,
--            eth_send              => eth_send,
--            src_addr              => src_addr,
--            dest_addr             => dest_addr,
--            oload_crc             => ovload_crc,
--            xgmii_txd             => xgmii_txd,
--            xgmii_txc             => xgmii_txc
--        );

    pktgen: mac_axis_packet_generator
        port map(
            clk_156               => clk_156,
            eth_send              => eth_send,
            src_addr              => src_addr,
            dest_addr             => dest_addr,
            tx_axis_aresetn       => aresetn,
            tx_axis_tdata         => mac_tx_tdata,
            tx_axis_tkeep         => mac_tx_tkeep,
            tx_axis_tvalid        => mac_tx_tvalid,
            tx_axis_tlast         => mac_tx_tlast,
            tx_axis_tready        => mac_tx_ready,
            rx_axis_aresetn       => aresetn,
            rx_axis_tdata         => mac_rx_tdata,
            rx_axis_tkeep         => mac_rx_tkeep,
            rx_axis_tvalid        => mac_rx_tvalid,
            rx_axis_tlast         => mac_rx_tlast,
            rx_axis_tready        => open
        );

    aresetn <= not areset;

    mac_0: ten_gig_eth_mac_0_support
        port map(
            clk_156               => clk_156,
            clk_locked            => sts_pcs_rx_lock,
            reset                 => areset,
            tx_reset              => cfg_mac_tx_reset,
            rx_reset              => cfg_mac_rx_reset,
            tx_axis_aresetn       => not areset,
            tx_axis_tdata         => mac_tx_tdata,
            tx_axis_tkeep         => mac_tx_tkeep,
            tx_axis_tready        => mac_tx_ready,
            tx_axis_tvalid        => mac_tx_tvalid,
            tx_axis_tlast         => mac_tx_tlast,
            rx_axis_aresetn       => aresetn,
            rx_axis_tdata         => open,
            rx_axis_tkeep         => open,
            rx_axis_tvalid        => open,
            rx_axis_tuser         => open,
            rx_axis_tlast         => open,
            xgmii_txd             => xgmii_txd,
            xgmii_txc             => xgmii_txc,
            xgmii_rxd             => xgmii_rxd,
            xgmii_rxc             => xgmii_rxc
        );

    eth_send_but: button_filter
    port map(
        clk                       => clk_100,
        in_pulse                  => cfg_eth_send,
        out_pulse                 => eth_send
    );
end Behavioral;
