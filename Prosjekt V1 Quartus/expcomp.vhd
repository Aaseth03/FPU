library IEEE; 
use IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
--use IEEE.STD_LOGIC_UNSIGNED.all;
--use IEEE.STD_LOGIC_ARITH.all;
--Ser hvilket tall som er lavest og sender det videre til bitshifting, sammen med hvor mye det m� bitshiftes
entity expcomp is
 port(expa, expb: in UNSIGNED(7 downto 0);
 	alessb: inout STD_LOGIC;
 	exp,shamt: out UNSIGNED(7 downto 0));

end;
architecture synth of expcomp is
 signal aminusb: UNSIGNED(7 downto 0);
 signal bminusa: UNSIGNED(7 downto 0);

begin

 aminusb <= expa - expb;
 bminusa <= expb - expa;
 alessb <= aminusb(7);
 exp <= expb when alessb = '1' else expa;
 shamt <= bminusa when alessb = '1' else aminusb;
 
 
end;