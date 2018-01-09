#include "script_component.hpp"

/*
  Name: TFAR_fnc_haveLRRadio

  Author: NKey, Garth de Wet (L-H)
    Returns whether the player has a LR radio

  Arguments:
    None

  Return Value:
    None

  Example:
    _hasLR = call TFAR_fnc_haveLRRadio;

  Public: Yes
 */

if (isNil "TFAR_currentUnit" || {isNull (TFAR_currentUnit)}) exitWith {false};

count (TFAR_currentUnit call TFAR_fnc_lrRadiosList) > 0
