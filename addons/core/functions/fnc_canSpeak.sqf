#include "script_component.hpp"

/*
  Name: TFAR_fnc_canSpeak

  Author: NKey
    Tests whether it would be possible to speak at the given eye height and whether the unit is within an isolated vehicle.

  Arguments:
    0:  Whether the unit is isolated and inside a vehicle. <BOOL>
    1:  The eye depth. <NUMBER>

  Return Value:
    Whether it is possible to speak. <BOOL>

  Example:
    _canSpeak = [false, -12] call TFAR_fnc_canSpeak;

  Public: Yes
*/

params ["_vehIsolation", "_eyeDepth"];

(_eyeDepth > 0 || _vehIsolation)
