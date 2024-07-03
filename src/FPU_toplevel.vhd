library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity FPU_toplevel is
 port(CLOCK_50		:	IN	STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Op_ctrl	:	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Tall_s	:	OUT UNSIGNED(31 DOWNTO 0)
		);
end;
architecture Behav of FPU_toplevel is

COMPONENT AddSub IS 
PORT(	CLK, Enable				:	IN STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Tall_s			:	OUT UNSIGNED(31 DOWNTO 0));
END COMPONENT;

COMPONENT Mult_expadd IS 
PORT(	CLK, Enable		:	IN	STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Tall_s			:	OUT UNSIGNED(31 DOWNTO 0));
END COMPONENT;

COMPONENT Div_expsub IS 
PORT( CLK,Enable		:	IN STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Tall_s			:	OUT UNSIGNED(31 DOWNTO 0));
END COMPONENT;

SIGNAL AddSub_enable, Mult_enable, Div_enable, CLK	:	STD_LOGIC := '0';
SIGNAL	AddSub_s, Mult_s, Div_s, Result	:	UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');

BEGIN


CLK <= CLOCK_50;


	PROCESS(Op_ctrl, AddSub_s, Mult_s, Div_s)
	BEGIN

		CASE(Op_ctrl) IS
			WHEN "01" => Result <= AddSub_s;
			WHEN "10" => Result <= Mult_s;
			WHEN "11" => Result <= Div_s;
			WHEN OTHERS => NULL;
			
		END CASE;
	END PROCESS;
	
	PROCESS(CLK, Result)
	BEGIN
		IF(RISING_EDGE(CLK)) THEN
			Tall_s <= Result;
		END IF;
	END PROCESS;



	--Addisjon & Subtraksjon
	AddSub_enable <= '1' WHEN (Op_ctrl = "01") ELSE '0';
	
	AS	:	AddSub PORT MAP(CLK, '1', Tall_a, Tall_b, AddSub_s);
	
	--Multiplikasjon
	Mult_enable <= '1' WHEN (Op_ctrl = "10") ELSE '0';
	
	Mult	:	Mult_expadd PORT MAP(CLK, '1', Tall_a, Tall_b, Mult_s);
	
	--Divisjon
	Div_enable <= '1' WHEN (Op_ctrl = "11") ELSE '0';
	
	Div	:	Div_expsub PORT MAP(CLK, '1', Tall_a, Tall_b, Div_s);
	

END Behav;
			
			