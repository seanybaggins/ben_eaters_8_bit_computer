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
  SIGNAL button : std_logic := 'X';
  SIGNAL input_1 : std_logic := '0';
  SIGNAL input_2 : std_logic := '1';
  SIGNAL output : std_logic;
BEGIN
  mux : ENTITY mux_2i_1o PORT MAP (
    button => button,
    input_1 => input_1,
    input_2 => input_2,
    output => output
    );

  main : PROCESS
  BEGIN
    test_runner_setup(runner, runner_cfg);

    WHILE test_suite LOOP
      IF run("correct begining state") THEN
        check(output = input_1, "Incorrect intial state");

      ELSIF run("button press to switch inputs") THEN
        button <= '0';
        wait for 20 ns;
        button <= '1';
        wait for 20 ns;
        check(output = input_2, "Input did not change when button was pressed");
      END IF;
    END LOOP;

    test_runner_cleanup(runner); -- Simulation ends here
    WAIT;
  END PROCESS;
END ARCHITECTURE;