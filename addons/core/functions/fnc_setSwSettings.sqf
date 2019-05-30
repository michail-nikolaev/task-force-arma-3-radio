#include "script_component.hpp"

/*
  Name: TFAR_fnc_setSwSettings

  Author: NKey
    Saves the settings for the passed radio and broadcasts it to all clients and the server.

  Arguments:
    0: Radio classname <STRING>
    1: Settings, usually acquired via TFAR_fnc_getSwSettings and then changed. <ARRAY>
    2: Set local only <BOOL>

  Return Value:
    None

  Example:
    _settings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
    _settings set [0, 2]; // sets the active channel to 2
    [call TFAR_fnc_activeSwRadio, _settings] call TFAR_fnc_setSwSettings;

  Public: Yes
*/

params ["_radio_id", "_value", ["_local", false, [true]]];

ENCRYPTION_CODE_CHECK((_value select TFAR_CODE_OFFSET) != "", _value)

TFAR_RadioSettingsNamespace setVariable [_radio_id, + _value,!_local];
TFAR_RadioSettingsNamespace setVariable [_radio_id + "_local", + _value];

GVAR(VehicleConfigCacheNamespace) setVariable ["lastRadioSettingUpdate",diag_tickTime];
