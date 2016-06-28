----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2016 01:43:42 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity button_filter is
    port (
        clk           : in  std_logic;
        in_pulse      : in  std_logic := '0';
        out_pulse     : out std_logic := '0'
    );
end button_filter;

architecture Behavioral of button_filter is
component FD is
    generic(
        INIT              : std_logic
    );
    port(
        C                 : in  std_logic;
        D                 : in  std_logic;
        Q                 : out std_logic
    );
end component;

signal xor_pulse         : std_logic := '0';
signal prev_pulse        : std_logic := '0';
signal pre2_pulse        : std_logic := '0';

begin
    last_state: FD
        generic map(
            INIT              => '0'
        ) port map(
            C                 => clk,
            D                 => in_pulse,
            Q                 => prev_pulse
        );


    last_state2: FD
        generic map(
            INIT              => '0'
        ) port map(
            C                 => clk,
            D                 => prev_pulse,
            Q                 => pre2_pulse
        );

    xor_pulse <= prev_pulse xor pre2_pulse;
    out_pulse <= (not pre2_pulse) and xor_pulse;
end Behavioral;
