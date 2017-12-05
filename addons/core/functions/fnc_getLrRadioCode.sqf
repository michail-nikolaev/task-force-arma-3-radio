#include "script_component.hpp"

/*
    Name: TFAR_fnc_getLrRadioCode

    Author(s):
        NKey
        L-H

    Description:
        Returns the encryption code for the passed radio.

    Parameters:
        Array: Radio
            0: OBJECT - Radio object
            1: STRING - Radio ID

    Returns:
        STRING - Encryption code

    Example:
        (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrRadioCode;
*/

If (GVARMAIN(radioCodesDisabled)) exitWith {""};

(_this call TFAR_fnc_getLrSettings) param [TFAR_CODE_OFFSET]
