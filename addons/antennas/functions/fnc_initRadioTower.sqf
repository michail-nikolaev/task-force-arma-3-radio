#include "script_component.hpp"

/*
    Name: TFAR_antennas_fnc_initRadioTower

    Author(s):
        Dedmen

    Description:
        Initializes a Radio Tower

    Parameters:
        OBJECT: the Tower
        NUMBER: the Transmitting Range of the Tower

    Returns:
        NOTHING

    Example:
        [_this,50000] call TFAR_antennas_fnc_initRadioTower;
*/
params ["_tower","_range"];

TRACE_1("TFAR_antennas_fnc_initRadioTower",_this);

[GVAR(radioTowerList), _tower, _range] call CBA_fnc_hashSet;

[FUNC(pluginAddRadioTower),[_tower]] call CBA_fnc_execNextFrame; //netID may still be 0:0 directly at Init EH
