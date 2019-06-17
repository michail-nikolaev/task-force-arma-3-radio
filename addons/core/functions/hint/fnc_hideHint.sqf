#include "script_component.hpp"

/*
  Name: TFAR_fnc_hideHint

  Author: Garth de Wet (L-H)
    Removes the hint from the bottom right

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_hideHint;

  Public: Yes
*/

("TFAR_HintLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
