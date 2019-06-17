#include "script_component.hpp"

/*
  Name: TFAR_fnc_getLrRadioCode

  Author: NKey, Garth de Wet (L-H)
    Returns the encryption code for the passed radio.

  Arguments:
    0: Radio object <OBJECT>
    1: Radio String <STRING>

  Return Value:
    Encryption code <STRING>

  Example:
    (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrRadioCode;

  Public: Yes
*/

if (GVARMAIN(radioCodesDisabled)) exitWith {""};

(_this call TFAR_fnc_getLrSettings) param [TFAR_CODE_OFFSET, ""]
