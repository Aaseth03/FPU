LIBRARY IEEE;
USE ieee.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY Mult_expadd_TB IS
END;

ARCHITECTURE synth of Mult_expadd_TB IS

COMPONENT Mult_expadd IS
PORT(	CLK				:	IN 	STD_LOGIC;
		Enable			:	IN	STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Tall_s			:	OUT UNSIGNED(31 DOWNTO 0));
END COMPONENT;

SIGNAL Tall_a, Tall_b, Svar	:	UNSIGNED(31 DOWNTO 0):= (OTHERS => '0');
SIGNAL CLK_s 	:	STD_LOGIC := '0';
BEGIN
	

CLK_s <= not CLK_s after 2 ns;

	test: PROCESS
	BEGIN
	Tall_a <= x"3f3b482c"; --0.73157
	Tall_b <= x"44371000"; --732.25
	WAIT FOR 20 ns;
	Tall_a <= x"3f800000"; -- 1
	Tall_b <= x"3f800000"; -- 1
	WAIT FOR 20 ns;
	Tall_a <= x"3dcccccd"; -- 0.1
	Tall_b <= x"41200000"; -- 10
		WAIT FOR 20 ns;
	Tall_a <= x"3e800000"; -- 0.25
	Tall_b <= x"3f000000"; -- 0.5
		WAIT FOR 20  ns;
	Tall_a <= x"3f000000"; -- 0.5
	Tall_b <= x"3f000000"; -- 0.5
		WAIT FOR 20  ns;
	Tall_a <= x"44455803"; --789.37519
	Tall_b <= x"3aef1d5a"; --0.0018243
		WAIT FOR 20  ns;
	Tall_a <= x"00000000"; -- 0
		WAIT FOR 20  ns;
	Tall_a <= x"FFFFFFFF"; -- NaN
		WAIT FOR 20  ns;
	Tall_a <= x"7FFFFFFF"; -- NaN
		WAIT FOR 20  ns;
	Tall_a <= x"FF800000"; -- -uendelig
		WAIT FOR 20  ns;
	Tall_a <= x"7F800000"; -- +uendelig
		WAIT FOR 20  ns;
	Tall_b <= x"00000000"; -- 0
		WAIT FOR 20  ns;
	Tall_a <= x"ff7fffff"; --sjekker overflow
	Tall_b <= x"7f7fffff";
		WAIT FOR 20  ns;
	Tall_a <= x"00000007"; --sjekker underflow
	Tall_b <= x"00000007";
		WAIT; 
	END PROCESS;

mult1 : Mult_expadd PORT MAP(CLK_s,'1',Tall_a,Tall_b,svar);


END synth;