#include "script_component.hpp"

/*
  Name: TFAR_fnc_onGroundHint

  Author: TFAR
    shows the "on ground" hint

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_onGroundHint;

  Public: No
*/



[parseText (localize LSTRING(on_ground_hint)), 5] call TFAR_fnc_showHint;
