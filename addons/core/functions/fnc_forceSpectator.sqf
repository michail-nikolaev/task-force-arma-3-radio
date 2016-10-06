#include "script_component.hpp"

/*
    Name: TFAR_fnc_forceSpectator

    Author(s):
        NKey

    Description:
        If second parameter is true player will force to be moved in spectator mode (at radio level).
        If false - normal behaviour restore.

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

if (_value) then {
    _player call TFAR_fnc_sendPlayerKilled;
};
_player setVariable ["tf_forceSpectator", _value, true];
