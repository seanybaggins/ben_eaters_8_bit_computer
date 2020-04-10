LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY src;
USE src.variable_clock;

ENTITY tb_variable_clock IS
    GENERIC (runner_cfg : STRING);
END ENTITY;

ARCHITECTURE tb OF tb_variable_clock IS
    SIGNAL is_fast : std_logic;
    SIGNAL variable_clock_output : std_logic;

    -- test bench internal signals
    Constant test_clock_frequency : Integer := 50_000_000;
    CONSTANT CLK_PERIOD : TIME := 20 ns;
    SIGNAL start : BOOLEAN := true; -- To indicate the test is done
    SIGNAL test_clk : std_logic := '0';
    SIGNAL test_clk_counter : INTEGER := 0;
    SIGNAL clk_output_counter : INTEGER := 0;
BEGIN
    variable_clock_instance : ENTITY variable_clock PORT MAP (
        clk_50_Mhz => test_clk,
        is_fast => is_fast,
        clk => variable_clock_output
        );

    test_clk <= NOT test_clk AFTER CLK_PERIOD / 2;

    increment_test_clk_counter : PROCESS (test_clk)
    BEGIN
        if rising_edge(test_clk) then
            test_clk_counter <= test_clk_counter + 1;
        end if;
    END PROCESS;

    increment_clk_output_counter : PROCESS (variable_clock_output)
    BEGIN
        IF rising_edge(variable_clock_output) THEN
            clk_output_counter <= clk_output_counter + 1;
        END IF;
    END PROCESS;

    main : PROCESS

        PROCEDURE run_test IS BEGIN
            info("Init test");
            WAIT UNTIL rising_edge(test_clk);
            start <= true;
            WAIT UNTIL rising_edge(test_clk);
            start <= false;
            WAIT UNTIL (rising_edge(test_clk));
            info("Test done");
        END PROCEDURE;

    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("varible clk fast output") THEN
                is_fast <= '1';
                WAIT for 50 ms; -- 1/20 sec
                check(clk_output_counter = 1, "Incorrect number of cycles for varible clk fast output");
                run_test;

            elsif run("variable clk slow output") then
                is_fast <= '0';
                wait for 1000 ms;
                check(clk_output_counter = 1, "Incorrect number of cycles for varialbe clk slow output");
                run_test;
            END IF;
        END LOOP;
        test_runner_cleanup(runner);
        WAIT;
    END PROCESS;
END ARCHITECTURE;