/*
 	Name: TFAR_fnc_canUseDDRadio
 	
 	Author(s):
		NKey

 	Description:
		Checks whether it is possible for the DD radio to be used at the current height and isolated status.
	
	Parameters:
		0: NUMBER - Depth
		1: BOOLEAN - Isolated and inside
 	
 	Returns:
		BOOLEAN
 	
 	Example:
		_canUseDD = [-12,true] call TFAR_fnc_canUseDDRadio;
*/
private ["_isolated_and_inside", "_depth"];

_depth = _this select 0;
_isolated_and_inside = _this select 1;

(_depth < 0) and !(_isolated_and_inside)