#include "script_component.hpp"

/*
  Name: TFAR_fnc_defaultPositionCoordinates

  Author: NKey
    Prepares the position coordinates of the passed unit.

  Arguments:
    0: unit <OBJECT>
    1: Is near player <BOOL>

  Return Value:
    position ASL <ARRAY>

  Example:
    [player, false] call TFAR_fnc_defaultPositionCoordinates;

  Public: Yes
*/

params ["_unit", "_isNearPlayer"];

if (_unit getVariable ["TFAR_forceSpectator",false]) exitWith {ATLToASL (positionCameraToWorld [0,0,0])};

private _current_eyepos = eyepos _unit;

//If this is not in here then positions inside fast moving vehicles will be weird. But this is also performance intensive
if ((_isNearPlayer) && {(vectorMagnitude (velocity _unit)) > 3} && {_unit != TFAR_currentUnit}) then {
        // This portion of the code appears that it will be extremely slow
        // It makes use of the 2 slower position functions.
        _renderAt = visiblePosition _unit;
        _pos = getPos _unit;
        // add difference between pos and eyepos to visiblePosition to get some kind of visiblePositionEyepos
        _current_eyepos = _renderAt vectorAdd (_current_eyepos vectorDiff _pos);
};
_current_eyepos
