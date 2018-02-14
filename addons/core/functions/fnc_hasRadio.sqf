#include "script_component.hpp"

/*
  Name: TFAR_fnc_hasRadio

  Author: Dorbedo
    Check if a unit has a radio

  Arguments:
    0: the unit <OBJECT>

  Return Value:
    the unit has a radio <BOOL>

  Example:
    _hasRadio = [_player] call TFAR_fnc_hasRadio;

  Public: Yes
 */

params [["_unit", objNull, [objNull]]];

if !(_unit isKindOf "CAManBase") exitWith {false};

(!((_unit call TFAR_fnc_backpackLr) isEqualTo []))
||{(count ([_unit] call TFAR_fnc_getRadioItems))>0}
