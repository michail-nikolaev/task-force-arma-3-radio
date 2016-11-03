#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrRadioCode

    Author(s):
        L-H

    Description:
        Allows setting of the encryption code for individual radios.

    Parameters:
        0: ARRAY - Radio
            0: OBJECT- Radio object
            1: STRING - Radio ID
        1: STRING - encryption Code

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeLrRadio, "NewEncryptionCode"] call TFAR_fnc_setLrRadioCode;
*/
params [["_radio",[],[[]],2],["_value","",[""]]];
_radio params ["_radio_object", "_radio_qualifier"];

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [TFAR_CODE_OFFSET, _value];
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;
