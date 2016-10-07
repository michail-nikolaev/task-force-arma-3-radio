#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwRadioCode

    Author(s):
        L-H

    Description:
        Allows setting of the encryption code for individual radios.

    Parameters:
        0: STRING - Radio classname
        1: STRING - Encryption code.

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeSwRadio, "NewEncryptionCode"] call TFAR_fnc_setSwRadioCode;
*/

params ["_radio_id", "_code_to_set"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [TF_CODE_OFFSET, _code_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;
