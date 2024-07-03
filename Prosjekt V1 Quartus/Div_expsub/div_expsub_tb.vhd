LIBRARY IEEE;
USE ieee.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY div_expsub_TB IS
END;

ARCHITECTURE synth of div_expsub_TB IS
COMPONENT Div_expsub IS 
	PORT(	CLK,Enable	:	IN	STD_LOGIC;
		Tall_a, Tall_b	:	IN	unsigned(31 DOWNTO 0);
		Tall_s			:	OUT unsigned(31 DOWNTO 0));
END COMPONENT;

SIGNAL Tall_a, Tall_b, Svar	:	UNSIGNED(31 DOWNTO 0):= (OTHERS => '0');
SIGNAL CLK,Enable		:	STD_LOGIC := '0';
BEGIN

CLK <= NOT(CLK) after 2 ns;

PROCESS
BEGIN
	Tall_a <= x"3f800000"; tall_b <= x"3f800000"; -- 1/1
	wait for 2 ns;
	Tall_b <= x"40000000"; -- 1/2
	wait for 2 ns;
	Tall_b <= x"bf800000";-- 1/(-1)
	wait for 2 ns;
	Tall_a <= x"00000000"; tall_b <= x"00000000"; -- 0/0
	wait for 2 ns;
	Tall_a <= x"FFFFFFFF"; tall_b <= x"00000000"; -- -inf/0
	wait for 2 ns;
	Tall_a <= x"00000000"; tall_b <= x"FFFFFFFF"; -- 0/-inf
	wait for 2 ns;
	Tall_a <= x"7FC00000"; tall_b <= x"40800000"; -- NaN / 4
	wait for 2 ns;
	Tall_a <= x"41d80000"; tall_b <= x"426EC28F";-- 27/59.69
	wait for 2 ns;
	Tall_a <= x"40000000"; Tall_b <= x"40400000"; --2/3
	wait for 2 ns;
	Tall_a <= x"3f418937"; Tall_b <= x"443d0000"; --0.756/756
	wait for 2 ns;
	Tall_a <= x"443d0000"; Tall_b <= x"3f418937"; --756/0.756
	WAIT;


END PROCESS;

test :	div_expsub PORT MAP (CLK,'1',Tall_a,Tall_b,Svar);
END synth;