library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY Div_expsub IS 
PORT( CLK,Enable		:	IN STD_LOGIC := '0';
		Tall_a, Tall_b	:	IN	unsigned(31 DOWNTO 0);
		Tall_s			:	OUT unsigned(31 DOWNTO 0));
END;



Architecture Behav of Div_expsub IS

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

SIGNAL exp_a,exp_b,exp_s	:	UNSIGNED(7 DOWNTO 0)	:= (OTHERS => '0');
SIGNAL exp_tmp	:	UNSIGNED (8 DOWNTO 0) := (OTHERS => '0');
SIGNAL mant_a,mant_b	:	UNSIGNED(23 DOWNTO 0) := (OTHERS => '0');
SIGNAL mant_tmp,mant_s	:	UNSIGNED (23 DOWNTO 0);
SIGNAL mant_tmpless	:	UNSIGNED(47 DOWNTO 0) := (OTHERS => '0');
SIGNAL sign_a,sign_b,sign_s	: STD_LOGIC := '0';
SIGNAL Zeros	:	NATURAL RANGE 0 to 25 := 0;
SIGNAL Z_in	:	UNSIGNED(24 DOWNTO 0) := (OTHERS => '0');
SIGNAL flag_a,flag_b	:	STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN


	
		--bruker tall_a og Tall_b istedenfor signalene slik at de går parallelt med erklæring av signal
		flag_a <= Spesialtilfeller(exp => Tall_a(30 DOWNTO 23), fracture => Tall_a(22 DOWNTO 0));
		flag_b <= Spesialtilfeller(exp => Tall_b(30 DOWNTO 23), fracture => Tall_b(22 DOWNTO 0));

		sign_a <= Tall_a(31);
		sign_b <= Tall_b(31);
		sign_s <= Tall_a(31) XOR Tall_b(31);
		
		exp_a <= Tall_a(30 DOWNTO 23);
		exp_b <= Tall_b(30 DOWNTO 23);
		--exp_tmp <= (exp_a + TO_UNSIGNED(127,exp_tmp'length)) - exp_b; -- pass på rekkefølgen for å unngå underflow
		
		mant_a <= '1' & Tall_a(22 DOWNTO 0);
		mant_b <= '1' & Tall_b(22 DOWNTO 0);
		
PROCESS(CLK,Enable)
BEGIN
	IF(RISING_EDGE(CLK) AND (Enable = '1')) THEN	
		Tall_s <= sign_s & exp_s & mant_s(23 DOWNTO 1);
	END IF;
END PROCESS;
	
PROCESS(flag_a,flag_b,exp_a,exp_b,mant_a,mant_b) -- Spesial tilfeller 
BEGIN

	CASE(flag_a) IS
		WHEN "00" =>
			CASE(flag_b) IS
				WHEN "00" => 
				--Vanlig operasjon
					 
					mant_tmpless <= (mant_a & x"000000")/(mant_b);--legger til flere nuller bak a, for et mer presist svar.
					mant_tmp <= mant_a/mant_b;

					
					exp_tmp <= (('0' & exp_a + TO_UNSIGNED(127,exp_tmp'length)) - ('0' & exp_b));
				
				WHEN "01" => 
				--Dele på NaN = NaN
					mant_tmp <= mant_a;
					exp_tmp <= (OTHERS => '1');
				
				WHEN "10" => 
				--Dele på uendelig = 0
					mant_tmp <= (OTHERS => '0');
					 exp_tmp <= (OTHERS => '0');

				WHEN "11" => 
				--Dele på 0 = uendelig
					mant_tmp <= (OTHERS => '0');
					 exp_tmp <= (OTHERS => '1');
				
				WHEN OTHERS => mant_tmp <= x"FAFAFA"; --Feilsøking
									 exp_tmp <= '0' & x"FA";
			END CASE;

		WHEN "01" =>
		--NaN dele på = NaN
			mant_tmp <= mant_a;
			 exp_tmp <= (OTHERS => '1');
		
		WHEN "10" =>
		--Uendelig delepå = uendelig
			IF(flag_b = "10") THEN
				mant_tmp <= mant_a;
				 exp_tmp <= (OTHERS => '1');
			ELSE
				mant_tmp <= (OTHERS => '0');
				 exp_tmp <= (OTHERS => '1');
			END IF;
		
		WHEN "11" =>
		-- 0 dele på
			IF(flag_b = "11") THEN --0/0 = NaN
				mant_tmp <= mant_a;
				 exp_tmp <= (OTHERS => '1');
			ELSE
				mant_tmp <= (OTHERS => '0');
				 exp_tmp <= (OTHERS => '0');
			END IF;
		
		WHEN OTHERS =>mant_tmp <= x"FAFAFA"; --Feilsøking
							exp_tmp <= '0' & x"FA";
	END CASE;

END PROCESS;

PROCESS(mant_a,mant_b,mant_tmp,mant_tmpless)
BEGIN
	IF(mant_a < mant_b) THEN
		z_in <= mant_tmpless(24 DOWNTO 0);
	ELSE
		Z_in <= ('0' & mant_tmp);
	END IF;
END PROCESS;

z_count	:	Z_COUNTER PORT MAP (Z_in, Zeros);


PROCESS(exp_tmp,Zeros,mant_tmp,mant_tmpless) -- Normalisering
BEGIN

	IF((flag_a = "00") AND (flag_b = "00")) THEN --Vanlig operasjon
		IF(exp_tmp(8) = '1') THEN
			IF(exp_tmp(7) = '1') THEN --underflow
				 exp_s <= (OTHERS => '0');
				mant_s <= (OTHERS => '0');
			ELSE --Overflow
				 exp_s <= (OTHERS => '1');
				mant_s <= (OTHERS => '1');
			END IF;
		ELSE 
			
			IF(Zeros = 24) THEN --mantissa a og b er like, ingen normalisering for exp nødvendig
				exp_s <= exp_tmp(7 DOWNTO 0);
			ELSE
				IF(mant_a < mant_b) THEN
					exp_s <= exp_tmp(7 DOWNTO 0) - TO_UNSIGNED(Zeros,exp_s'length);
					mant_s <= SHIFT_LEFT(mant_tmpless(23 DOWNTO 0), Zeros);
				ELSE
					exp_s <= exp_tmp(7 DOWNTO 0) - TO_UNSIGNED(Zeros,exp_s'length);
					mant_s <= SHIFT_LEFT(mant_tmp, Zeros); --skal være Zeros+1 for å få bort ledende ener, 
																	--men også (Zeros+1)-1 siden det ble lagt til en ekstra 0 foran for Z_Counter
				END IF;
			END IF;
		END IF;
		
	ELSE --spesialtilfeller
		exp_s <= exp_tmp(7 DOWNTO 0);
		mant_s <= mant_tmp;
	END IF;

END PROCESS;


END Behav;
