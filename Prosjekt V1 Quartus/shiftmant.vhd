library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
--use IEEE.std_logic_unsigned.all;
--Bitshifter det laveste tallet til � ha like mange bit som det h�yeste
entity shiftmant is

 port(alessb: in STD_LOGIC;
	manta: in UNSIGNED(23 downto 0);
	mantb: in UNSIGNED(23 downto 0);
	shamt: in UNSIGNED(7 downto 0);
 	shmant: out UNSIGNED(23 downto 0));
end;

architecture synth of shiftmant is
 signal shiftedval: unsigned (23 downto 0);
 signal shiftamt_vector: UNSIGNED (7 downto 0);

begin
 shiftedval <= SHIFT_RIGHT( unsigned(manta), to_integer(unsigned(shamt))) when alessb = '1' 
else SHIFT_RIGHT( unsigned(mantb), to_integer(unsigned(shamt)));
--shifted mantissa er shiftedval om ikke overflow
 shmant <= X"000000" when (shamt > 22) else UNSIGNED(shiftedval);
end;


