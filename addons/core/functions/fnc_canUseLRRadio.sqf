#include "script_component.hpp"

/*
    Name: TFAR_fnc_canUseLrRadio

    Author(s):
        NKey

    Description:
        Checks whether the radio would be able to be used at passed depth.

    Parameters:
        0: OBJECT - Unit
        1: BOOLEAN - Isolated and inside
        2: BOOLEAN - Can Speak
        3: NUMBER - Depth

    Returns:
        BOOLEAN

    Example:
        _canUseSW = [player, false, false, 10] call TFAR_fnc_canUseLrRadio;
*/

params ["_player", "_isolated_and_inside", "_depth"];

if (_depth > 0) exitWith {true};

if ((vehicle _player != _player) and {_depth > TF_UNDERWATER_RADIO_DEPTH}) then {
    if ((_isolated_and_inside) or {isAbleToBreathe _player}) exitWith {true};
};

false
