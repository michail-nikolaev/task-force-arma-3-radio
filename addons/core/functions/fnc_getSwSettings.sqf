#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSwSettings

  Author: NKey, Garth de Wet (L-H)
    Returns the current settings for the passed radio.

  Arguments:
    Radio classname <STRING>

  Return Value:
    settings <ARRAY>

  Example:
    (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;

  Public: Yes
*/
params[["_radio", "", [""]]];

private _value = TFAR_RadioSettingsNamespace getVariable _radio;
if (!isNil "_value") exitWith {_value};

if (isNil QGVAR(saved_active_sr_settings)) then  {
    _value = true call DFUNC(getDefaultRadioSettings);
} else {
    _value = GVAR(saved_active_sr_settings);
    GVAR(saved_active_sr_settings) = nil;
};

private _rc = _value select TFAR_CODE_OFFSET;
if (isNil "_rc") then {
    private _code = [_radio, "tf_encryptionCode", ""] call DFUNC(getWeaponConfigProperty);

    if (_code == "tf_guer_radio_code") then {_code = "tf_independent_radio_code"};

    If (_code != "") then {
        _value set [TFAR_CODE_OFFSET, missionNamespace getVariable [_code, ""]];
    } else {
        _value set [TFAR_CODE_OFFSET, ""];
    };
};

[_radio, _value, true] call TFAR_fnc_setSwSettings;

_value
