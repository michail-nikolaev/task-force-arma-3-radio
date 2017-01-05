#include "script_component.hpp"

/*
    Name: TFAR_fnc_forceSpectator

    Author(s):
        NKey

    Description:
        If second parameter is true player will moved to spectator mode
        If false - normal behaviour will be restored.

    Parameters:
        ARRAY:
            0 - Object - Player
            1 - Boolean - Force or not

    Returns:
        Nothing

    Example:
        [player, true] call TFAR_fnc_forceSpectator;
*/

params ["_player", "_value"];

_player setVariable ["TFAR_forceSpectator", _value, true];
_player setVariable ["TFAR_spectatorName", profileName, true];
