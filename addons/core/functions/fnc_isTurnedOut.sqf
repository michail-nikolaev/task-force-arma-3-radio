#include "script_component.hpp"

/*
  Name: TFAR_fnc_isTurnedOut

  Author: NKey
    returns if a unit is turened out

  Arguments:
    0: unit <OBJECT>

  Return Value:
    is turned out <BOOL>

  Example:
    [_unit] call TFAR_fnc_isTurnedOut;

  Public: No
*/

params ["_unit"];

WARNING('Deprecated function used: TFAR_fnc_isTurnedOut (new: CBA_fnc_isTurnedOut) in ADDON');
[_unit] call CBA_fnc_isTurnedOut
