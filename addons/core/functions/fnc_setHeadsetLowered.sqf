#include "script_component.hpp"

/*
  Name: TFAR_fnc_setHeadsetLowered

  Author: Dedmen
    Sets if the Headset is currently lowered

  Arguments:
    0: Headset lowered <BOOL>

  Return Value:
    None

  Example:
    true call TFAR_fnc_setHeadsetLowered;

  Public: Yes
*/
params [["_lowered", false, [false]]];

//Using Plugin settngs framework because its easier to use for this. And doesn't clutter FREQ command
//Benchmarking this returned 0.024ms per call
GVAR(isHeadsetLowered) = _lowered;
["headsetLowered", _lowered] call TFAR_fnc_setPluginSetting;
