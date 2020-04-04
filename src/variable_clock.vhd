LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

ENTITY variable_clock IS
    PORT (
        clk_50_MHz : IN std_logic;
        is_fast : IN std_logic;
        clk : OUT std_logic
    );
END variable_clock;

ARCHITECTURE RTL OF variable_clock IS
    CONSTANT FAST_MAX_CYCLE_COUNT : INTEGER := 2500000;
    CONSTANT SLOW_MAX_CYCLE_COUNT : INTEGER := 50000000;

    SIGNAL counter : INTEGER := 0;

BEGIN
    set_output : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE is_fast IS
                WHEN '1' =>
                    -- divided by 2 for a 50 % duty cycle
                    clk <= '1' WHEN ((counter MOD FAST_MAX_CYCLE_COUNT) < FAST_MAX_CYCLE_COUNT / 2)
                        ELSE
                        clk <= '0';
                WHEN '0' =>
                    clk <= '1' WHEN ((counter MOD SLOW_MAX_CYCLE_COUNT) < SLOW_MAX_CYCLE_COUNT / 2)
                        ELSE
                        clk <= '0';
            END CASE;
        END IF;
    END PROCESS;
END RTL;