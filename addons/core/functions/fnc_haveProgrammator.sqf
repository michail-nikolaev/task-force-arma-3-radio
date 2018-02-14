#include "script_component.hpp"

/*
  Name: TFAR_fnc_haveProgrammator

  Author: NKey, Garth de Wet (L-H)
    Returns whether the player has a programmer

  Arguments:
    None

  Return Value:
    has a programmer <BOOL>

  Example:
    _hasProgrammer = call TFAR_fnc_haveProgrammator;

  Public: Yes
 */

if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith {false};
"TFAR_microdagr" in (assignedItems TFAR_currentUnit);
