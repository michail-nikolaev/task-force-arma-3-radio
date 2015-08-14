/*
 	Name: TFAR_fnc_backpackLR
 	
 	Author(s):
		NKey

 	Description:
		Returns the backpack radio (if there is one)
	
	Parameters:
<<<<<<< HEAD
		0: Object: Unit
=======
		Nothing
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Returns:
		ARRAY: Manpack or empty array
 	
 	Example:
<<<<<<< HEAD
		_radio = player call TFAR_fnc_backpackLR;
*/
private ["_result", "_backpack"];
_result = [];
_backpack = backpack _this;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty) == 1) then {
	_result = [unitBackpack _this, "radio_settings"];
=======
		_radio = call TFAR_fnc_backpackLR;
*/
private ["_result", "_backpack"];
_result = [];
_backpack = backpack player;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty) == 1) then
{
	_result = [unitBackpack player, "radio_settings"];
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
_result