#include "script_component.hpp"

/*
    Name: TFAR_fnc_currentDirection

    Author(s):
        NKey

    Description:
        Returns current direction of players head.

    Parameters:
        Nothing

    Returns:
        0: NUMBER: head direction azimuth

    Example:
        call TFAR_fnc_currentDirection
*/

private _current_look_at = (screenToWorld [0.5,0.5]) vectorDiff (eyepos TFAR_currentUnit);
private _current_look_at params ["_current_look_at_x", "_current_look_at_y", "_current_look_at_z"];

private _current_rotation_horizontal = 0;
private _current_hyp_horizontal = sqrt(_current_look_at_x * _current_look_at_x + _current_look_at_y * _current_look_at_y);

if (_current_hyp_horizontal > 0) then {
    if (_current_look_at_x < 0) then {
        _current_rotation_horizontal = round - acos(_current_look_at_y / _current_hyp_horizontal);
    }else{
        _current_rotation_horizontal = round acos(_current_look_at_y / _current_hyp_horizontal);
    };
};
while{_current_rotation_horizontal < 0} do {
    _current_rotation_horizontal = _current_rotation_horizontal + 360;
};
_current_rotation_horizontal;
