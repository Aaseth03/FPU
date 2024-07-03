library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity fpadder is
 port(Tall_a, Tall_b	: 	IN STD_LOGIC_VECTOR(31 downto 0);
		RST, Enable		:	IN	STD_LOGIC;
		Tall_s			: 	OUT STD_LOGIC_VECTOR(31 downto 0));
end;
architecture synth of fpadder is

SIGNAL	sign_a, sign_b, sign_s		:	STD_LOGIC := '0';
SIGNAL	exp_a, exp_b, exp_s			:	UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL	mant_a, mant_b, mant_s		:	UNSIGNED(23 DOWNTO 0) := (OTHERS => '0');
SIGNAL	flag_a,flag_b					:	STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

PROCESS()
BEGIN
	IF(RST = '1') THEN
		sign_a	<= '0';
		sign_b	<= '0';
		sign_s	<= '0';
		
		exp_a 	<= (OTHERS <= '0');
		exp_b 	<=	(OTHERS <= '0');
		exp_s		<= (OTHERS <= '0');
		
		mant_a	<= (OTHERS <= '0');
		mant_b	<= (OTHERS <= '0');
		mant_s	<= (OTHERS <= '0');
	
	ELSIF((RST = '0') AND (Enable = '1')) THEN
		sign_a <= Tall_a(31);
		sign_b <= Tall_b(31);
		
		exp_a <= Tall_a(30 DOWNTO 23);
		exp_b <= Tall_b(30 DOWNTO 23);
		
		mant_a <= '1' & Tall_a(22 DOWNTO 0);
		mant_b <= '1' & Tall_b(22 DOWNTO 0);
		
		CASE((sign_a & sign_b)) IS
			WHEN "00" =>
			
			WHEN "01" =>
			
			WHEN "10" =>
			
			WHEN "11" =>
			
		END CASE;
	END IF;
			