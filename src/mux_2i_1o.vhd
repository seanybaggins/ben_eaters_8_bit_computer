LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_2i_1o IS
	PORT (
		button : IN std_logic;
		input_1 : IN std_logic;
		input_2 : IN std_logic;
		output : OUT std_logic
	);
END mux_2i_1o;

ARCHITECTURE RTL OF mux_2i_1o IS
	SIGNAL switch : std_logic := '0';
BEGIN
	output <= input_1 WHEN (switch = '0') ELSE
		input_2;
	PROCESS (button) IS
	BEGIN
		IF rising_edge(button) THEN
			switch <= NOT switch;
		END IF;
	END PROCESS;
END RTL;