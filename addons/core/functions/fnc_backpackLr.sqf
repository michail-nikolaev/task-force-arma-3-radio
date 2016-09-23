/*
 	Name: TFAR_fnc_backpackLR
 	
 	Author(s):
		NKey

 	Description:
		Returns the backpack radio (if there is one)
	
	Parameters:
		0: Object: Unit
 	
 	Returns:
		ARRAY: Manpack or empty array
 	
 	Example:
		_radio = player call TFAR_fnc_backpackLR;
*/
private ["_result", "_backpack"];
_result = [];
_backpack = backpack _this;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty) == 1) then {
	_result = [unitBackpack _this, "radio_settings"];
};
_result