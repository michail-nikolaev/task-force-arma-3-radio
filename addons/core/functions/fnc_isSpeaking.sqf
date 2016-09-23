/*
 	Name: TFAR_fnc_isSpeaking
 	
 	Author(s):
		L-H

 	Description:
		Check whether a unit is speaking
	
	Parameters:
		OBJECT - Unit
		
 	Returns:
		BOOLEAN - If the unit is speaking
 	
 	Example:
		if (player call TFAR_fnc_isSpeaking) then {
			hint "You are speaking";
		};
*/
(("task_force_radio_pipe" callExtension format ["IS_SPEAKING	%1", name _this]) == "SPEAKING")