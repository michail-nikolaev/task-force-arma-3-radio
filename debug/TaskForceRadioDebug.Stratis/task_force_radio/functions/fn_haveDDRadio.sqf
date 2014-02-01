private ["_currentVest", "_rebreather"];
if ((vest player) == "V_RebreatherB") exitWith {true};
_rebreather = configFile >> "CfgWeapons" >> "V_RebreatherB";
_currentVest = configFile >> "CfgWeapons" >> (vest player);
[_currentVest, _rebreather] call CBA_fnc_inheritsFrom