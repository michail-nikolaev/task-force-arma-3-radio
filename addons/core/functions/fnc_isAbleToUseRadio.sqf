#include "script_component.hpp"

/*
  Name: TFAR_fnc_isAbleToUseRadio

  Author: NKey, Garth de Wet (L-H)
    Checks whether the current unit is able to use their radio.

  Arguments:
    None

  Return Value:
    is able to use <BOOL>

  Example:
    _ableToUseRadio = call TFAR_fnc_isAbleToUseRadio;

  Public: Yes
 */

!(TFAR_currentUnit getVariable ["tf_unable_to_use_radio", false])//Externally used Variable. Don't change name
