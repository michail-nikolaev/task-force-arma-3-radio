/*
 	Name: TFAR_fnc_getSideRadio
 	
 	Author(s):
		L-H
 	
 	Description:
		Returns the default radio for the passed side.
 	
 	Parameters:
		0: SIDE - side
		1: NUMBER - radio type : Range [0,2] (0 - LR, 1 - SW, 2 - Rifleman)
 	
 	Returns:
		STRING/OBJECT - Default Radio
 	
 	Example:
		_defaultLRRadio = [side player, 0] call TFAR_fnc_getSideRadio;
		_defaultSWRadio = [side player, 1] call TFAR_fnc_getSideRadio;
		_defaultRiflemanRadio = [side player, 2] call TFAR_fnc_getSideRadio;
*/
private ["_side", "_radioType", "_result", "_variable"];
_side = _this select 0;
_radioType = _this select 1;
_result = "";

_variable = "TF_default" + str(_side);

switch (_radioType) do {
	case 0: {
		_result = missionNamespace getVariable (_variable + "Backpack");
	};
	case 1: {
		_result = missionNamespace getVariable (_variable + "PersonalRadio");
	};
	case 2:	{
		_result = missionNamespace getVariable (_variable + "RiflemanRadio");
	};
};

_result