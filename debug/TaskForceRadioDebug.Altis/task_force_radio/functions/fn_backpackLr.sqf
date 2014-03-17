private ["_result", "_backpack"];
_result = [];
_backpack = backpack player;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty) == 1) then
{
	_result = [unitBackpack player, "radio_settings"];
};
_result