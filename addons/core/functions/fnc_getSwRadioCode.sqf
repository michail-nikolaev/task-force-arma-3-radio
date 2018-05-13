#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSwRadioCode

  Author: NKey, Garth de Wet (L-H)
    Returns the encryption code for the passed radio.

  Arguments:
    Radio classname <STRING>

  Return Value:
    Encryption code <STRING>

  Example:
    (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode;

  Public: Yes
*/
params[["_radio", "", [""]]];

if (GVARMAIN(radioCodesDisabled)) exitWith {""};

(_radio call TFAR_fnc_getSwSettings) param [TFAR_CODE_OFFSET, ""]
