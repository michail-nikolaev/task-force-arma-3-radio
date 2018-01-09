#include "script_component.hpp"

/*
  Name: TFAR_fnc_currentDirection

  Author: NKey, Dedmen
    Returns current direction of Units head.

  Arguments:
    0: unit to get the Head direction from. <UNIT> (Default: TFAR_currentUnit)

  Return Value:
    current look direction in Normalized 3D Vector <ARRAY>

  Example:
    TFAR_currentUnit call TFAR_fnc_currentDirection;

  Public: Yes
 */
params [["_unit", TFAR_currentUnit, [objNull]]];

if (_unit getVariable ["TFAR_forceSpectator",false]) exitWith {(positionCameraToWorld [0,0,1]) vectorDiff (positionCameraToWorld [0,0,0])};

getCameraViewDirection _unit
