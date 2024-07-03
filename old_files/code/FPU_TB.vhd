library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY FPU_TB IS
END;

ARCHITECTURE TB OF FPU_TB IS


COMPONENT FPU_toplevel is
 PORT(CLOCK_50		:	IN	STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Op_ctrl	:	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Tall_s	:	OUT UNSIGNED(31 DOWNTO 0)
		);
END COMPONENT;

SIGNAL	Tall_a, Tall_b, Tall_s	:	UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');
SIGNAL	CLK	:	STD_LOGIC := '0';
SIGNAL	Op_ctrl	:	STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
BEGIN

CLK <= NOT(CLK) after 125 ps;

test:	PROCESS
		BEGIN
			
			wait for 2 ns;
			Tall_a <= x"3f800000";	Tall_b <= x"3f800000"; Op_ctrl <= "00"; --1 og 1
			wait for 2 ns;
			Tall_a <= x"40000000";	Tall_b <= x"c0000000"; Op_ctrl <= "01"; --2 + -2
			wait for 2 ns;
			Tall_a <= x"40400000";	Tall_b <= x"41100000"; Op_ctrl <= "10"; --3 * 9
			wait for 2 ns;
			Tall_a <= x"c0400000";	Tall_b <= x"41100000"; Op_ctrl <= "01"; -- -3/9
			wait for 2 ns;
			Tall_a <= x"41100000";	Tall_b <= x"c0400000"; Op_ctrl <= "01"; -- 9/-3
			wait for 2 ns;
			Tall_a <= x"411f0a3d";	Tall_b <= x"b851b717"; Op_ctrl <= "10"; --9.94 * -0.00005
			wait for 2 ns;
			Tall_a <= x"7f7fffff";	Tall_b <= x"40400000"; Op_ctrl <= "00";-- 3.4e38 og 3
			wait for 2 ns;
			Tall_a <= x"c0000000";	Tall_b <= x"40a00000"; Op_ctrl <= "01"; -- -2/5
			wait for 2 ns;
			Tall_a <= x"40000000";	Tall_b <= x"c0a00000"; Op_ctrl <= "01"; -- 2/-5
			wait for 2 ns;
			Tall_a <= x"40800000";	Tall_b <= x"bf800000"; Op_ctrl <= "01"; -- 4/-1
			wait for 2 ns;
			Tall_a <= x"c1100000";	Tall_b <= x"40000000"; Op_ctrl <= "01"; -- -9/2
			wait for 2 ns;
			Tall_a <= x"7f800000";	Tall_b <= x"ccbc614f"; -- inf og -98765432
			wait for 2 ns;
			Tall_a <= x"00000001";	Tall_b <= x"00800000"; -- 1e-45 og 1.175e-38
			wait for 2 ns;
			
			WAIT;
		
		END PROCESS;
		
		FPU1	:	FPU_toplevel PORT MAP (CLK, Tall_a, Tall_b, Op_ctrl, Tall_s);


END TB;