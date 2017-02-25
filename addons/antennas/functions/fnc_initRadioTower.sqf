#include "script_component.hpp"

/*
    Name: TFAR_antennas_fnc_initRadioTower

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
diag_log ["TFAR_antennas_fnc_initRadioTower",_this];
[GVAR(radioTowerList), _tower, _range] call CBA_fnc_hashSet;

[DFUNC(pluginAddRadioTower),[_tower]] call CBA_fnc_execNextFrame; //netID may still be 0:0 directly at Init EH
