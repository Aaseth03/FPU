library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY addsub_tb IS
END;

ARCHITECTURE TB OF addsub_tb IS

COMPONENT AddSub IS 
PORT(	CLK				:	IN STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Tall_s			:	OUT UNSIGNED(31 DOWNTO 0));
END COMPONENT;

SIGNAL CLK	:	STD_LOGIC := '0';
SIGNAL Tall_a, Tall_b, Tall_s : UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');
BEGIN


CLK <= NOT(CLK) after 125 ps;
test1 : PROCESS
BEGIN
	
	wait for 1 ns;
	Tall_a <= x"3f800000"; Tall_b <= x"00000000"; --1+0 = 1
	Wait for 2 ns;
	Tall_a <= x"3f800000"; Tall_b <= x"3f800000"; --1+1 = 2
	Wait for 2 ns;
	Tall_a <= x"40000000"; Tall_b <= x"c0000000";-- 2-2 = !
	Wait for 2 ns;
	Tall_a <= x"40000000"; Tall_b <= x"40800000";-- 2+4 = 7 (shift mant left 1)
	Wait for 2 ns;
	Tall_a <= x"41100000"; Tall_b <= x"40400000"; --9+3 = 14 (shift mant left 1)
	Wait for 2 ns;
	Tall_a <= x"41100000"; Tall_b <= x"c0400000";-- 9-3 = 48 (exp -3)
	Wait for 2 ns;
	Tall_a <= x"c0000000"; Tall_b <= x"00000000";-- -2+0 = -2
	Wait for 2 ns;
	Tall_a <= x"c0000000"; Tall_b <= x"c0000000"; -- -2-2 = -4
	Wait for 2 ns;
	Tall_a <= x"c0000000"; Tall_b <= x"c0a00000";-- -2-5 = -10 (exp -1 og mant MSB høy)
	Wait for 2 ns;
	Tall_a <= x"41000000"; Tall_b <= x"c0800000"; -- 8-4 = 32 (exp -3)
	Wait for 2 ns;
	Tall_a <= x"7f800000"; Tall_b <= x"80000000";-- inf-0 = inf
	Wait for 2 ns;
	Tall_a <= x"7fc00000"; Tall_b <= x"40000000"; --Nan+2 = NaN
	Wait for 2 ns;
	Tall_a <= x"40000000"; Tall_b <= x"40a00000";-- 2+5 = 7
	Wait for 2 ns;
	Tall_a <= x"438e1090"; Tall_b <= x"c2bb7f9c";--284.1294 - 93.74924
	Wait for 2 ns;
	
	
	Wait;

END PROCESS;

test:	addsub PORT MAP(CLK, Tall_a, Tall_b, Tall_s);

END TB;