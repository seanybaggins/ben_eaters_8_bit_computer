LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY src;
USE src.mux_2i_1o;

ENTITY tb_variable_clock IS
    GENERIC (runner_cfg : STRING);
END ENTITY;

architecture tb of tb_variable_clock is 
    signal is_fast : in std_logic := '1';
    signal variable_clock_output out : std_logic;

    -- test bench internal signals
    CONSTANT clk_period : TIME := 20 ns;
    SIGNAL start : BOOLEAN := true; -- To indicate the test is done
    SIGNAL test_clk : in std_logic := '0';
begin
    variable_clock : ENTITY variable_clock port map (
        test_clk => clk_50_Mhz,
        is_fast => is_fast,
        variable_clock_output => clk
    )
end architecture