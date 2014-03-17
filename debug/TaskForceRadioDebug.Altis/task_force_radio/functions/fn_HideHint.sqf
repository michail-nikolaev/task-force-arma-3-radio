/*
 	Name: TFAR_fnc_HideHint
 	
 	Author(s):
		L-H
 	
 	Description:
	Removes the hint from the bottom right
 	
 	Parameters:
	Nothing
 	
 	Returns:
	Nothing
 	
 	Example:
	call TFAR_fnc_HideHint;
 */
("TFAR_HintLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];