LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.STD_LOGIC_UNSIGNED.all;
USE ieee.NUMERIC_STD.all;
-- Counts to k-1 in an signal n-bit long
ENTITY MOD_Counter IS
	GENERIC(	k	:	INTEGER;
				n	:	NATURAL);
	PORT(CLK		:	IN	STD_LOGIC;
		  Enable	:	IN	STD_LOGIC;
		  Q		:	OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  RST		:	IN	STD_LOGIC;
		  ROLL : OUT STD_LOGIC);
END MOD_COUNTER;

ARCHITECTURE Behav OF MOD_COUNTER IS
	Signal	V	:	STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL	rollover:	STD_LOGIC:='0';
BEGIN
	
	PROCESS(Enable,CLK,RST,V)
	BEGIN
		IF(RST = '1') THEN
			V <= (OTHERS => '0');
		ELSIF (RISING_EDGE(CLK) AND(Enable = '1')) THEN
			IF(V >= k-1) THEN
				V <= (OTHERS => '0');
				rollover <= '1';
			ELSE
				V <= V + 1;
				rollover <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	Q <= V;
	ROLL <= rollover;
END Behav;