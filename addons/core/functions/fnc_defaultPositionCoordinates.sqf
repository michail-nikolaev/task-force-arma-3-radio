#include "script_component.hpp"

/*
    Name: TFAR_fnc_defaultPositionCoordinates

    Author(s):
        NKey

    Description:
        Prepares the position coordinates of the passed unit.

    Parameters:
        0: OBJECT - unit
        1: BOOLEAN - Is near player

    Returns:
        Nothing

    Example:

*/

params ["_unit", "_isNearPlayer"];

private _current_eyepos = eyepos _unit;
private _current_rotation_horizontal = 0;

if (_unit != TFAR_currentUnit) then {
    if (_isNearPlayer) then {
        // This portion of the code appears that it will be extremely slow
        // It makes use of the 2 slower position functions.
        _renderAt = visiblePosition _unit;
        _pos = getPos _unit;
        // add different between pos and eyepos to visiblePosition to get some kind of visiblePositionEyepos
        _current_eyepos = _renderAt vectorAdd (_current_eyepos vectorDiff _pos);
    };
    // for now it used only for player
    if (alive TFAR_currentUnit) then {
        _current_eyepos = _current_eyepos vectorDiff (eyePos TFAR_currentUnit);
    };
} else {
    _current_rotation_horizontal = call TFAR_fnc_currentDirection;
    _current_eyepos = [0,0,0];
};
_current_eyepos pushBack _current_rotation_horizontal;
_current_eyepos
