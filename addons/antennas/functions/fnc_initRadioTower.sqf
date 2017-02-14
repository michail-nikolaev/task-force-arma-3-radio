#include "script_component.hpp"

/*
    Name: TFAR_fnc_initRadioTower

    Author(s):
        Dedmen

    Description:
        Initializes a Radio Tower

    Parameters:
        OBJECT: the Tower

    Returns:
        NOTHING

    Example:
        _this call TFAR_fnc_initRadioTower;
*/
params ["_tower","_range"];

[GVAR(radioTowerList), _tower, _range] call CBA_fnc_hashSet;

[_tower] call TFAR_fnc_pluginAddRadioTower;
