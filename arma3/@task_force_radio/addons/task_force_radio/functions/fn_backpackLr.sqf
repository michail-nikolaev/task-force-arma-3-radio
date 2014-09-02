/*
 	Name: TFAR_fnc_backpackLR
 	
 	Author(s):
		NKey

 	Description:
		Returns the backpack radio (if there is one)
	
	Parameters:
		Nothing
 	
 	Returns:
		ARRAY: Manpack or empty array
 	
 	Example:
		_radio = call TFAR_fnc_backpackLR;
*/
private ["_result", "_backpack"];
_result = [];
_backpack = backpack player;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty) == 1) then {
	_result = [unitBackpack player, "radio_settings"];
};
_result