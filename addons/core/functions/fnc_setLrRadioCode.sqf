#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrRadioCode

    Author(s):
        L-H

    Description:
        Allows setting of the encryption code for individual radios.

    Parameters:


    Returns:
        Nothing

    Example:
        [(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, "NewEncryptionCode"] call TFAR_fnc_setLrRadioCode;
*/
params ["_radio_object", "_radio_qualifier", "_value"];

private _settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
_settings set [TF_CODE_OFFSET, _value];
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;
