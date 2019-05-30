#include "script_component.hpp"

/*
  Name: TFAR_fnc_setLrRadioCode

  Author: Garth de Wet (L-H)
    Allows setting of the encryption code for individual radios.

  Arguments:
    0: LR Radio <ARRAY>
    1: encryption Code <STRING>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeLrRadio, "NewEncryptionCode"] call TFAR_fnc_setLrRadioCode;

  Public: Yes
*/
params [["_radio", [], [[]], 2], ["_value", "", [""]]];
_radio params ["_radio_object", "_radio_qualifier"];

ENCRYPTION_CODE_CHECK(_value != "", _value)

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [TFAR_CODE_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setLrSettings;
