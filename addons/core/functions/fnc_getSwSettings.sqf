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
    _value = [true, TFAR_currentUnit, _radio] call DFUNC(getDefaultRadioSettings);
} else {
    _value = GVAR(saved_active_sr_settings);
    GVAR(saved_active_sr_settings) = nil;

    ENCRYPTION_CODE_CHECK((_value select TFAR_CODE_OFFSET) != "", _value)
};

[_radio, _value, true] call TFAR_fnc_setSwSettings;

_value
