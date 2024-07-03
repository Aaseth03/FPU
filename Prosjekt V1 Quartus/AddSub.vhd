library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY AddSub IS 
PORT(	CLK, Enable		:	IN STD_LOGIC;
		Tall_a, Tall_b	:	IN	UNSIGNED(31 DOWNTO 0);
		Tall_s			:	OUT UNSIGNED(31 DOWNTO 0));
END;

ARCHITECTURE behav of AddSub IS

COMPONENT Z_COUNTER IS
	PORT(
		addresult	:	IN		UNSIGNED(24 DOWNTO 0);
		Zeros			:	OUT	NATURAL := 0
		);
END COMPONENT;

function Spesialtilfeller (exp : unsigned(7 DOWNTO 0) := (OTHERS => '0');
									fracture	:	unsigned(22 DOWNTO 0) := (OTHERS => '0');
									sign	:	STD_LOGIC := '0') 
									return STD_LOGIC_VECTOR is
									VARIABLE flag	:	STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
									begin
									IF((exp = x"00") AND (fracture = to_unsigned(0,fracture'length))) THEN -- 0
										flag :=  "11";
									ELSIF(exp = x"FF") THEN
									
										IF(fracture = to_unsigned(0,fracture'length)) THEN -- +- uendelig, skiller ikke
											flag := "10";
										ELSIF(fracture /= to_unsigned(0,fracture'length)) THEN -- NaN
											flag := "01";
										END IF;
									ELSE
										flag := "00"; --settes til 00 for å spare strøm i stedenfor 11, denne vil returneres flest ganger
									END IF;
									return STD_LOGIC_VECTOR(flag);
									end function;

SIGNAL 	sign_a, sign_b, sign_s :	STD_LOGIC := '0';
SIGNAL	exp_a, exp_b, exp_s, exp_pre	:	UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL	mant_a, mant_b	:	UNSIGNED(23 DOWNTO 0) := (OTHERS => '0');
SIGNAL	flag_a, flag_b	:	STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
SIGNAL	exp_aminusb, exp_bminusa, shamt:	UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL 	exp_alessb	:	STD_LOGIC := '0';
SIGNAL 	shmant, shmant_tmp, addval	:	UNSIGNED(23 DOWNTO 0) := (OTHERS => '0');
SIGNAL	mant_s, mant_s_im	:	UNSIGNED(24 DOWNTO 0) := (OTHERS => '0');
SIGNAL	fract_s	:	UNSIGNED(22 DOWNTO 0) := (OTHERS => '0');
SIGNAL	Z	:	INTEGER RANGE 0 TO 25 := 0;
SIGNAL	sign_con	:	STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN

sign_a <= Tall_a(31);
sign_b <= Tall_b(31);

exp_a <= Tall_a(30 DOWNTO 23);
exp_b <= Tall_b(30 DOWNTO 23);

mant_a <= ('1' & Tall_a(22 DOWNTO 0));
mant_b <= ('1' & Tall_b(22 DOWNTO 0));

sign_s <= ( (sign_b AND exp_alessb) OR (sign_a AND NOT(exp_alessb)) );

PROCESS(CLK,sign_s,exp_s,fract_s)
BEGIN
	IF(RISING_EDGE(CLK) AND (Enable = '1')) THEN
		Tall_s <= (sign_s & exp_s) & fract_s;
	END IF;
END PROCESS;

	flag_a <= Spesialtilfeller(exp => Tall_a(30 DOWNTO 23), fracture => Tall_a(22 DOWNTO 0));
	flag_b <= Spesialtilfeller(exp => Tall_b(30 DOWNTO 23), fracture => Tall_b(22 DOWNTO 0));

	
	--mantissa
PROCESS(flag_a, flag_b, addval, Tall_a, Tall_b, mant_s_im, exp_aminusb, exp_bminusa, exp_alessb, shamt, shmant, exp_pre, Z, sign_con, CLK)
BEGIN 

-- Spesialtilfeller

		
	IF((flag_a = "01") OR (flag_b = "01")) THEN -- NaN
		fract_s <= (OTHERS => '1');
		exp_s <=	(OTHERS =>'1');
		
	ELSIF((flag_a = "10") OR (flag_b = "10")) THEN --+- uendelig
		fract_s <= (OTHERS => '0');
		exp_s <=	(OTHERS =>'1');

	ELSIF((flag_a = "11") AND (flag_b = "11")) THEN --0
		fract_s <= (OTHERS => '0');
		exp_s <=	(OTHERS =>'0');

	ELSIF((flag_a = "11") AND (flag_b = "00")) THEN --0
		fract_s <= Tall_b(22 DOWNTO 0);
		exp_s	<= exp_b;
	ELSIF((flag_b = "11") AND (flag_a = "00")) THEN --0
		fract_s <= Tall_a(22 DOWNTO 0);
		exp_s <= exp_a;
	ELSIF(Tall_a(30 DOWNTO 0) = Tall_b(30 DOWNTO 0)) THEN -- to like tall
		IF((sign_a XOR sign_b) = '1') THEN -- motsatt fortegn
			fract_s <= (OTHERS => '0');
			exp_s <= (OTHERS => '0');
		ELSE --samme fortegn
			fract_s <= Tall_a(22 DOWNTO 0);
			exp_s <= Tall_a(30 DOWNTO 23) + TO_UNSIGNED(1, exp_s'length); -- exp+1 tilsvarer å gange med 2
		END IF;
	
	
	ELSE --normal operasjon
		--adderer mantissaer
		mant_s_im <= ('0' & shmant) + ('0' & addval);
		
		IF((sign_a XOR sign_b) = '1') THEN --toer komplimentert regnestykke, mist MSB
			mant_s <= "0" & mant_s_im(mant_s_im'length-2 DOWNTO 0);
		ELSE
			mant_s <= mant_s_im;
		END IF;
		
		--normalisering
		IF( (sign_a XOR sign_b)  = '1') THEN
			fract_s <= SHIFT_LEFT(mant_s(mant_s'length-1 DOWNTO mant_s'length-fract_s'length), Z+1);
			exp_s <= exp_pre - TO_UNSIGNED(Z-1, exp_s'length); --- endret z til z-1

		ELSE

			IF(mant_s(mant_s'length-1) = '0') THEN
				fract_s <= SHIFT_LEFT(mant_s(mant_s'length-1 DOWNTO mant_s'length-fract_s'length), 2);
				exp_s <= exp_pre; -- TO_UNSIGNED(1, exp_s'length);
			ELSE
				
				IF(mant_s(mant_s'length-2) = '1') THEN --overflow
					fract_s <= (OTHERS => '0');
					exp_s <= (OTHERS => '1');
				ELSE
					
					fract_s <= SHIFT_LEFT(mant_s(mant_s'length-1 DOWNTO mant_s'length-fract_s'length), 1);
					exp_s <= exp_pre;
				END IF;
			END IF;
		
		END IF;
		
		
		
		exp_aminusb	<= exp_a - exp_b;
		exp_bminusa	<= exp_b - exp_a;

		exp_alessb	<= exp_aminusb(7);
		
		sign_con <= sign_a & sign_b;
		
		IF(exp_alessb = '1') THEN

			exp_pre	<= exp_b;
			shamt 	<= exp_bminusa;
		
			case(sign_con) IS
				
				WHEN "00" => 	addval <= mant_b;
									shmant <= SHIFT_RIGHT(mant_a, TO_INTEGER(shamt));
									
				WHEN "01" => 	addval <= mant_b;
									shmant <= (NOT(SHIFT_RIGHT(mant_a, TO_INTEGER(shamt))) + TO_UNSIGNED(1, shmant'length));
									
				WHEN "10" => 	addval <= (NOT(mant_b) + TO_UNSIGNED(1, addval'length));
									shmant <= SHIFT_RIGHT(mant_a, TO_INTEGER(shamt));
									
				WHEN "11" => 	addval <= mant_b;
									shmant <= SHIFT_RIGHT(mant_a, TO_INTEGER(shamt));
									
				WHEN OTHERS =>	NULL; 
			END CASE;
		

		ELSIF(exp_alessb = '0') THEN

			exp_pre	<= exp_a;
			shamt 	<= exp_aminusb;
		
			case(sign_con) IS
				
				WHEN "00" => 	addval <= mant_a;
									shmant <= SHIFT_RIGHT(mant_b, TO_INTEGER(shamt));
									
				WHEN "01" => 	addval <= mant_a;
									shmant <= (NOT(SHIFT_RIGHT(mant_b, TO_INTEGER(shamt))) + TO_UNSIGNED(1, shmant'length));
									
				WHEN "10" => 	addval <= (NOT(mant_a) + TO_UNSIGNED(1, addval'length));
									shmant <= SHIFT_RIGHT(mant_b, TO_INTEGER(shamt));
									
				WHEN "11" => 	addval <= mant_a;
									shmant <= SHIFT_RIGHT(mant_b, TO_INTEGER(shamt));
									
				WHEN OTHERS => NULL; 
			END CASE;
			
		END IF;
	END IF;
END PROCESS;

z_count	:	Z_COUNTER PORT MAP( mant_s, Z);

END Behav;