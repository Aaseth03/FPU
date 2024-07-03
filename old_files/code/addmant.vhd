library IEEE; use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--Legger sammen tallene etter bitshift
entity addmant is
 port(
	alessb	: 	IN 	STD_LOGIC;
	signa		:	IN		STD_LOGIC;
	signb		:	IN 	STD_LOGIC;
 	manta		: 	IN 	UNSIGNED(23 downto 0);
 	mantb		: 	IN 	UNSIGNED(23 downto 0);
 	shmant	: 	IN 	UNSIGNED(23 downto 0);
 	exp_pre	: 	IN 	UNSIGNED(7 downto 0);
 	fract		:	OUT 	UNSIGNED(22 downto 0);
 	exp		:	OUT 	UNSIGNED(7 downto 0);
	signs		:	OUT	STD_LOGIC);
end;

architecture synth of addmant is

COMPONENT Z_COUNTER IS
	PORT(
		addresult	:	IN		UNSIGNED (24 DOWNTO 0);
		Zeros			:	OUT	NATURAL := 0
		);
END COMPONENT;

COMPONENT encoder is
 port(
	a		:	IN	UNSIGNED(4 downto 0);
 	s		: OUT NATURAL RANGE 0 to 4;
	zflag	: OUT	STD_LOGIC);
end COMPONENT;



 signal addresult,addresult_tmp, fract_tmp	: 	UNSIGNED(24 downto 0) := "0000000000000000000000000";
 signal addval		: 	UNSIGNED(23 downto 0) := (OTHERS => '0');
 SIGNAL	signcon	:	STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
 signal	Zeros		:	NATURAL := 0;

begin

 addval <= mantb when alessb = '1' else manta;
 signcon <= signa & signb;
 
 PROCESS(signa, signb, signcon, shmant, addval, addresult)
 BEGIN
	  CASE (signcon) IS
	  -- standard addisjon
			WHEN	"00"	=> addresult_tmp <= (('0' & shmant) + addval); 

-- b er negativ, om alessb = 1 så er addval = mantb og shmant = manta			
			WHEN	"01"	=> IF (alessb = '1') THEN
								addresult_tmp <= '0' & (shmant - addval);  
								ELSE 
								addresult_tmp <= '0' & (addval - shmant);
								END IF;
-- a er negativ, rekkefølgen endres								
			WHEN	"10"	=> IF (alessb = '1') THEN
								addresult_tmp <= '0' & (addval - shmant);  
								ELSE 
								addresult_tmp <= '0' & (shmant - addval);
								END IF;
		-- to negative tall, behandles som standard addisjon 				
			WHEN	"11"	=> addresult_tmp <= (('0' & shmant) + addval);
			
			WHEN OTHERS => addresult_tmp <= "1010101010101010101010101"; --feilsøking
		END CASE;
END PROCESS;

-- Om a-b og b>a må svaret konverteres positivt i toer komplimentært, sjekkes om a-b(MSB) = '1'.
addresult <= (Not(addresult_tmp)+1) WHEN ((addresult_tmp(23) = '1') AND ((signa XOR signb) = '1')) ELSE addresult_tmp;

z_count1 :	Z_COUNTER PORT MAP(addresult, Zeros);

--Normalisering
PROCESS(signa, signb, addresult, Zeros, exp_pre)
BEGIN
	IF(signa /= signb) THEN
		--Ulike Fortegn
		IF(Zeros = 25) THEn
			fract_tmp <= addresult;
			exp <= exp_pre;
		ELSE
			fract_tmp <=  (shift_left(addresult,Zeros));
			exp	<=	(exp_pre - to_UNSIGNED(Zeros,exp_pre'length));
		END IF;
	ELSE
		-- like fortegn
		exp <= exp_pre + ("" & addresult(24));
		
		IF(addresult(24) = '1') THEN
			fract_tmp <= addresult(23 DOWNTO 1) & "00"; 
		ELSE 
			fract_tmp <= addresult(22 DOWNTO 0) & "00";
		END IF;
	END IF;
END PROCESS;
		
fract <= fract_tmp(23 DOWNTO 1); --skal ikke ha med første bit
		
signs	<= (((signa AND NOT(alessb)) OR (signa AND NOT(alessb)) OR (signa AND signb)) OR (addresult(23) AND (signa XOR signb)));


END synth;
