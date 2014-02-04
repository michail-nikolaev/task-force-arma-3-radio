private ["_result", "_backpack"];
_result = [];
_backpack = backpack player;
if (getNumber(ConfigFile >> "CfgVehicles" >> _backpack >> "tf_hasLRradio") == 1) then
{
	_result = [unitBackpack player, "radio_settings"];
};
_result