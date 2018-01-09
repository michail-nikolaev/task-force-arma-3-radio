#include "script_component.hpp"

/*
  Name: TFAR_fnc_isSpeaking

  Author: Garth de Wet (L-H)
    Check whether a unit is speaking

  Arguments:
    Unit <OBJECT>

  Return Value:
    the unit is speaking <BOOL>

  Example:
    if (player call TFAR_fnc_isSpeaking) then {
        hint "You are speaking";
    };

  Public: Yes
 */

(("task_force_radio_pipe" callExtension format ["IS_SPEAKING	%1", name _this]) == "SPEAKING")
