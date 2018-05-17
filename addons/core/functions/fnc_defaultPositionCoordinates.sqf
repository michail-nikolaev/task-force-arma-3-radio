#include "script_component.hpp"

/*
  Name: TFAR_fnc_defaultPositionCoordinates

  Author: NKey
    Prepares the position coordinates of the passed unit.

  Arguments:
    0: unit <OBJECT>
    1: Is near player <BOOL>

  Return Value:
    0: Position ASL. <ARRAY>
    1: View Direction. <ARRAY>

  Example:
    [player, false] call TFAR_fnc_defaultPositionCoordinates;

  Public: No
*/

//Implicitly passed by TFAR_fnc_preparePositionCoordinates
//params ["_unit", "_isNearPlayer"];

if (_isSpectating) exitWith {private _pctw = positionCameraToWorld [0,0,0]; [ATLToASL _pctw, (positionCameraToWorld [0,0,1]) vectorDiff _pctw]};

//If this is not in here then positions inside fast moving vehicles will be weird. But this is also performance intensive
if (_isNearPlayer && {vectorMagnitude velocity _unit > 3} && {_unit != TFAR_currentUnit}) exitWith {
        [(visiblePosition _unit) vectorAdd ((eyepos _unit) vectorDiff (getPos _unit)), getCameraViewDirection _unit]
};
[eyepos _unit,  getCameraViewDirection _unit]
