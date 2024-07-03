library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
--use IEEE.std_logic_unsigned.all;

ENTITY Mult_expadd IS 
PORT(	CLK, Enable		:	IN	STD_LOGIC;
		Tall_a, Tall_b	:	IN	unsigned(31 DOWNTO 0);
		Tall_s			:	OUT unsigned(31 DOWNTO 0));
END;



Architecture Behav of Mult_expadd IS

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

SIGNAL	sign_a, sign_b, sign_s				:	STD_LOGIC := '0';
SIGNAL	exp_a, exp_b, exp_s					:	UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL	fract_a, fract_b, fract_s			:	UNSIGNED(22 DOWNTO 0) := (OTHERS => '0');
SIGNAL 	fract_s_m								:	UNSIGNED(47 DOWNTO 0) := (OTHERS => '0');
SIGNAL	flag_a,flag_b							:	STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	exp_sum									:	UNSIGNED(8 DOWNTO 0);

BEGIN

	
	
	
	--bruker tall_a og Tall_b istedenfor signalene slik at de går parallelt med erklæring av signal
	flag_a <= Spesialtilfeller(exp => Tall_a(30 DOWNTO 23), fracture => Tall_a(22 DOWNTO 0));
	flag_b <= Spesialtilfeller(exp => Tall_b(30 DOWNTO 23), fracture => Tall_b(22 DOWNTO 0));
	
	PROCESS(CLK,sign_s,exp_s,fract_s)
	BEGIN
		IF((RISING_EDGE(CLK)) AND (Enable = '1')) THEN
				Tall_s <= (sign_s & exp_s) & fract_s;
		END IF;
		
	END PROCESS;
	
	PROCESS(flag_a,flag_b,sign_a,sign_b, exp_sum, fract_s,fract_s_m, Tall_a,Tall_b)
	
	BEGIN


				sign_a <= Tall_a(31);
				sign_b <= Tall_b(31);
				
				exp_a <= Tall_a(30 DOWNTO 23);
				exp_b <= Tall_b(30 DOWNTO 23);
				
				fract_a <= Tall_a(22 DOWNTO 0);
				fract_b <= Tall_b(22 DOWNTO 0);
			-- Spesialtilfeller
			IF((flag_a = "11") OR (flag_b = "11")) THEN --0
				fract_s <= (OTHERS => '0');
				exp_s <=	(OTHERS =>'0');
				sign_s <= sign_a XOR sign_b;
				
			ELSIF((flag_a = "01") OR (flag_b = "01")) THEN -- NaN
				fract_s <= (OTHERS => '1');
				exp_s <=	(OTHERS =>'1');
				sign_s <= sign_a XOR sign_b;
				
			ELSIF((flag_a = "10") OR (flag_b = "10")) THEN --+- uendelig
				fract_s <= (OTHERS => '0');
				exp_s <=	(OTHERS =>'1');
				sign_s <= '1';
				
			ELSE 
				--Vanlig operasjon
				-- Multipliserer mantissa
				fract_s_m <= ('1' & fract_a) * ('1' & fract_b);
				-- Normaliserer mantissa om nødvendig
				IF (fract_s_m(47) = '1') THEN
					fract_s <= ('0' & fract_s_m(45 DOWNTO 24));
					
					--Regner ut resultat eksponent
					exp_sum <= ('0' & exp_a) + ('0' & exp_b) - to_unsigned(127, exp_sum'length) + to_unsigned(1, exp_sum'length);
				ELSE
					fract_s <= fract_s_m(45 DOWNTO 23);
					
					--Regner ut resultat eksponent
					exp_sum <= ('0' & exp_a) + ('0' & exp_b) - to_unsigned(127, exp_sum'length);
				END IF;
				

				--sjekker overflow eller underflow
				IF (exp_sum(8) = '1') THEN
					IF(exp_sum(7) = '0') THEN 	--overflow
						exp_s <= (OTHERS => '1');
						fract_s <= (OTHERS => '0');
						sign_s <= sign_a XOR sign_b;

					ELSE	-- underflow
						exp_s <= (OTHERS => '0');
						fract_s <= (OTHERS => '0');
						sign_s <= '0';
					END IF;
				ELSE	-- vanlig operasjon
					exp_s <= exp_sum(7 DOWNTO 0);
					sign_s <= sign_a XOR sign_b;
				END IF;
			END IF;
--		END IF;
	END PROCESS;

END Behav;