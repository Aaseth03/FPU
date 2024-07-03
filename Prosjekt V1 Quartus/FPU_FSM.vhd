library IEEE;



entity FPU_FSM is
 port( Op_controll	:	IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
 );
end;

architecture behav of FPU_FSM is

--Declare State types
TYPE State_type IS (Add, Sub, Mult, Div, Exp);
--Attribute to declare a specific encoding for the states
attribute syn_encoding : string;
attribute syn_encoding of State_type : type is "000 001 010 011 100";
SIGNAL y_Q, Y_D : State_type; -- y_Q is present state, y_D is next state
BEGIN


PROCESS()
BEGIN
	case y_Q IS
		WHEN  =>
	
	END CASE;
END PROCESS;
