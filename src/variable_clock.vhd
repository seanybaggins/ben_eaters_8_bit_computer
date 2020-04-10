LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY variable_clock IS
    PORT (
        clk_50_MHz : IN std_logic;
        is_fast : IN std_logic;
        clk : OUT std_logic := '1' -- Will imediately be flipped first iteration of the set_output process
    );
END variable_clock;

ARCHITECTURE RTL OF variable_clock IS
    CONSTANT FAST_MAX_CYCLE_COUNT : INTEGER := 2_500_000;
    CONSTANT SLOW_MAX_CYCLE_COUNT : INTEGER := 50_000_000;
    SIGNAL counter : INTEGER := 0;

BEGIN
    increment_counter : PROCESS (clk_50_MHz)
    BEGIN
        IF rising_edge(clk_50_MHz) THEN
            counter <= counter + 1;
        END IF;
    END PROCESS;

    set_output : PROCESS (clk_50_MHz)
    BEGIN
        IF rising_edge(clk_50_MHz) THEN
            CASE is_fast IS
                WHEN '1' =>
                    -- dividing by 2 for 20 % duty cycle
                    clk <= NOT clk WHEN ((counter MOD (FAST_MAX_CYCLE_COUNT / 2)) = 0);

                WHEN OTHERS =>
                    -- dividing by 2 for 20 % duty cycle
                    clk <= NOT clk WHEN ((counter MOD (SLOW_MAX_CYCLE_COUNT / 2)) = 0);
            END CASE;
        END IF;
    END PROCESS;
END RTL;