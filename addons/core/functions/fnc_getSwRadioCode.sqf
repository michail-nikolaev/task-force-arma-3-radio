#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwRadioCode

    Author(s):
        NKey
        L-H

    Description:
        Returns the encryption code for the passed radio.

        Parameters:
    0: STRING - Radio classname

    Returns:
        STRING - Encryption code

    Example:
        (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode;
*/
params[["_radio","",[""]]];

If (GVARMAIN(radioCodesDisabled)) exitWith {""};

(_radio call TFAR_fnc_getSwSettings) param [TFAR_CODE_OFFSET,""]
