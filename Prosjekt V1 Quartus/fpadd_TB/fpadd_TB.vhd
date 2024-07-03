
LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
USE ieee.NUMERIC_STD.all;

ENTITY fpadd_TB IS
END fpadd_TB;

ARCHITECTURE Behavior OF fpadd_TB IS

COMPONENT fpadd is
 port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
 	s: out STD_LOGIC_VECTOR(31 downto 0));
end COMPONENT;

   	SIGNAL tall_a : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"fafafafa";
   	SIGNAL tall_b : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"fafafafa";
	SIGNAL Sum : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	
	
BEGIN
   test: PROCESS           
	BEGIN
	WAIT for 4 ns;
	tall_a <= X"3f800000"; tall_b <= X"3f800000"; -- 1+1
	WAIT FOR 4 ns;
	tall_a <= X"40000000"; tall_b <= x"bf800000"; -- 2-1
	wait for 4 ns;
	tall_a <= X"bf800000"; tall_b <= x"3f800000"; --- -1+1
	wait for 4 ns;
	tall_b <= X"bf800000"; -- -1-1
	wait for 4 ns;
	tall_a <= x"40000000"; tall_b <= X"40400000"; -- 2+3
	wait for 4 ns;
	tall_a <= x"c0400000"; tall_b <= X"40000000"; -- -3 + 2
	wait for 4 ns;
	tall_a <= X"c0a00000"; tall_b <= X"40000000"; -- -5+2
	wait for 4 ns;
	tall_a <= X"c0000000"; tall_b <= X"40000000"; -- -2+2
	wait for 4 ns;
	tall_a <= x"c256f0a4"; tall_b <= x"42b6b333"; -- -53.735 + 91.35
		WAIT;
      END PROCESS;                                          

   U1: fpadd PORT MAP (tall_a, tall_b, Sum);
	
	
END;