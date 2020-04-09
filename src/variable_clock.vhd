LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY variable_clock IS
    PORT (
        clk_50_MHz : IN std_logic;
        is_fast : IN std_logic;
        clk : OUT std_logic := '0'
    );
END variable_clock;

ARCHITECTURE RTL OF variable_clock IS
    CONSTANT FAST_MAX_CYCLE_COUNT : INTEGER := 2_500_000;
    CONSTANT SLOW_MAX_CYCLE_COUNT : INTEGER := 50_000_000;
    SIGNAL counter : INTEGER := 0;

BEGIN
    increment_counter : PROCESS (clk_50_MHz)
    BEGIN
        counter <= counter + 1;
    END PROCESS;

    set_output : PROCESS (clk_50_MHz)
    BEGIN
        IF rising_edge(clk_50_MHz) THEN
            CASE is_fast IS
                WHEN '1' =>
                    -- x by 2 for a 50 % duty cycle
                    clk <= '0' WHEN ((counter MOD FAST_MAX_CYCLE_COUNT) < FAST_MAX_CYCLE_COUNT)
                        ELSE
                        '1';
                WHEN OTHERS =>
                    clk <= '0' WHEN ((counter MOD SLOW_MAX_CYCLE_COUNT) < SLOW_MAX_CYCLE_COUNT/2)
                        ELSE
                        '1';
            END CASE;
        END IF;
    END PROCESS;
END RTL;