#include "script_component.hpp"

/*
    Name: TFAR_antennas_fnc_deleteRadioTower

    Author(s):
        Dedmen

    Description:
        De-Initializes a Radio Tower

    Parameters:
        OBJECT: the Tower

    Returns:
        NOTHING

    Example:
        _this call TFAR_fnc_deleteRadioTower;
*/

[GVAR(radioTowerList), _tower] call CBA_fnc_hashRem;

[_tower] call DFUNC(pluginRemoveRadioTower);
