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

if (_unit getVariable ["TFAR_forceSpectator",false]) exitWith {ATLToASL (positionCameraToWorld [0,0,0])};

private _current_eyepos = eyepos _unit;


/* This code is slow and it doesn't seem to make a big difference
//tested No difference on buildings or underwater
if ((_isNearPlayer) && {_unit != TFAR_currentUnit}) then {
        // This portion of the code appears that it will be extremely slow
        // It makes use of the 2 slower position functions.
        _renderAt = visiblePosition _unit;
        _pos = getPos _unit;
        // add difference between pos and eyepos to visiblePosition to get some kind of visiblePositionEyepos
        _current_eyepos = _renderAt vectorAdd (_current_eyepos vectorDiff _pos);
};
*/
_current_eyepos
