#include "script_component.hpp"

/*
  Name: TFAR_fnc_setLrSettings

  Author: NKey
    Saves the settings for the passed radio and broadcasts it to all clients and the server.

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>
    2: Settings, usually acquired via TFAR_fnc_getLrSettings and then changed. <ARRAY>

  Return Value:
    None

  Example:
    _settings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getSwSettings;
    _settings set [0, 2]; // sets the active channel to 2
    [call TFAR_fnc_activeLrRadio, _settings] call TFAR_fnc_setLrSettings;

  Public: Yes
 */

params [["_radio", [], [[]], 2], ["_value", [], [[]]]];
_radio params ["_radio_object", "_radio_qualifier"];

_radio_object setVariable [_radio_qualifier, + _value, true];

GVAR(VehicleConfigCacheNamespace) setVariable ["lastRadioSettingUpdate", diag_tickTime];
