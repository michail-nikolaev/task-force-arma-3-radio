#include "script_component.hpp"

/*
  Name: TFAR_fnc_unableToUseHint

  Author: Garth de Wet (L-H)
    shows the "unable to use" hint

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_unableToUseHint;

  Public: No
 */


[parseText (localize LSTRING(unable_to_use_hint)), 5] call TFAR_fnc_showHint;
