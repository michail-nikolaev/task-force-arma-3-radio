/*
 	Name: TFAR_fnc_haveDDRadio

 	Author(s):

 	Description:
		Returns whether the player has a DD radio.

 	Parameters:
	Nothing

 	Returns:
	Bool

 	Example:
	_hasDD = call TFAR_fnc_haveDDRadio;
 */
 if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith{false};
private ["_currentVest", "_rebreather"];
if (isNil "TF_dd_frequency") then {
	TF_dd_frequency = (group TFAR_currentUnit) getVariable "tf_dd_frequency";
};
if ((vest TFAR_currentUnit) == "V_RebreatherB") exitWith {true};
_rebreather = configFile >> "CfgWeapons" >> "V_RebreatherB";
_currentVest = configFile >> "CfgWeapons" >> (vest TFAR_currentUnit);
[_currentVest, _rebreather] call CBA_fnc_inheritsFrom
