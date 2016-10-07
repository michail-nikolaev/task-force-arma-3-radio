#include "script_component.hpp"

/*
    Name: TFAR_fnc_canUseSWRadio

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
        _canUseSW = [player, false, false, 10] call TFAR_fnc_canUseSwRadio;
*/

params ["_player", "_isolated_and_inside", "_can_speak", "_depth"];

private _result = false;

if (_depth > 0) then {
    _result = true;
} else {
    if (_can_speak and {_depth > -1} and {vehicle _player != _player}) then {
        if (_isolated_and_inside or {isAbleToBreathe _player}) then {
            _result = true;
        };
    };
};
_result
