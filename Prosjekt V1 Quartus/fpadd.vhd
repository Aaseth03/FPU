library IEEE; 
use IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
--use IEEE.STD_LOGIC_UNSIGNED.all;
--use IEEE.STD_LOGIC_ARITH.all;

entity fpadd is
 port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
 	s: out STD_LOGIC_VECTOR(31 downto 0));
end;
architecture synth of fpadd is

 component expcomp
	 port(
		expa, expb	: in 		UNSIGNED(7 downto 0);
		alessb		: inout 	STD_LOGIC;
 		exp,shamt	: out 	UNSIGNED(7 downto 0));
 end component;

 component shiftmant
 	port(
		alessb	: in 	STD_LOGIC;
 		manta		: in 	UNSIGNED(23 downto 0);
 		mantb		: in 	UNSIGNED(23 downto 0);
		shamt		: in 	UNSIGNED(7 downto 0);
 		shmant	: out UNSIGNED(23 downto 0));
 end component;

 component addmant
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
 end component;


 signal expa, expb	: UNSIGNED(7 downto 0);
 signal exp_pre, exp	: UNSIGNED(7 downto 0);
 signal shamt			: UNSIGNED(7 downto 0);
 signal alessb			: STD_LOGIC;
 SIGNAL signa			: STD_LOGIC;
 SIGNAL signb			: STD_LOGIC;
 SIGNAL signs			: STD_LOGIC;
 signal manta			: UNSIGNED(23 downto 0);
 signal mantb			: UNSIGNED(23 downto 0);
 signal shmant			: UNSIGNED(23 downto 0);
 signal fract			: UNSIGNED(22 downto 0);
 

begin
 signa <= a(31);
 expa <= UNSIGNED(a(30 downto 23));
 manta <= UNSIGNED('1' & a(22 downto 0));
 
 signb <= b(31);
 expb <= UNSIGNED(b(30 downto 23));
 mantb <= UNSIGNED('1' & b(22 downto 0));
 
 s <= STD_LOGIC_VECTOR(signs & exp & fract);
 
 expcomp1: expcomp 
 port map(expa, expb, alessb, exp_pre, shamt);
 
 shiftmant1: shiftmant
 port map(alessb, manta, mantb, shamt, shmant);
 
 addmant1: addmant
 port map(alessb, signa, signb, manta, mantb, shmant, 
 exp_pre, fract, exp, signs);
end;
