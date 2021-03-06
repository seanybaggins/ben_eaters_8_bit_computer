LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY src;
USE src.mux_2i_1o;

ENTITY tb_mux_2i_1o IS
    GENERIC (runner_cfg : STRING);
END ENTITY;

ARCHITECTURE tb OF tb_mux_2i_1o IS
    -- signals for unit under test
    SIGNAL button : std_logic := 'X';
    SIGNAL input_1 : std_logic := '0';
    SIGNAL input_2 : std_logic := '1';
    SIGNAL output : std_logic;

    -- test bench internal signals
    CONSTANT clk_period : TIME := 20 ns;
    SIGNAL start : BOOLEAN := true; -- To indicate the test is done
    SIGNAL clk : std_logic := '0';

BEGIN
    mux : ENTITY mux_2i_1o PORT MAP (
        button => button,
        input_1 => input_1,
        input_2 => input_2,
        output => output
        );

    clk <= not clk after clk_period / 2;

    main : PROCESS

        PROCEDURE run_test IS BEGIN
            info("Init test");
            WAIT UNTIL rising_edge(clk);
            start <= true;
            WAIT UNTIL rising_edge(clk);
            start <= false;
            WAIT UNTIL (rising_edge(clk));
            info("Test done");
        END PROCEDURE;

    BEGIN
        test_runner_setup(runner, runner_cfg);

        WHILE test_suite LOOP
            IF run("correct_begining_state") THEN
                WAIT FOR 20 ns;
                check(output = input_1, "Incorrect intial state");
                run_test;

            ELSIF run("button_press_to_switch_inputs") THEN
                button <= '0';
                check(output = input_1);
                WAIT FOR 20 ns;
                button <= '1';
                WAIT FOR 20 ns;
                check(output = input_2, "Input did not change when button was pressed");
                run_test;

            END IF;

        END LOOP;

        test_runner_cleanup(runner);
        WAIT;
    END PROCESS;
END ARCHITECTURE;