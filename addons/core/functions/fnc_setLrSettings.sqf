#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrSettings

    Author(s):
        NKey

    Description:
        Saves the settings for the passed radio and broadcasts it to all clients and the server.

    Parameters:
        0: OBJECT- Radio object
        1: STRING - Radio ID
        2: ARRAY - Settings, usually acquired via TFAR_fnc_getLrSettings and then changed.

    Returns:
        Nothing

    Example:
        _settings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getSwSettings;
        _settings set [0, 2]; // sets the active channel to 2
        [call TFAR_fnc_activeLrRadio, _settings] call TFAR_fnc_setLrSettings;
*/

params [["_radio",[],[[]],2], ["_value",[],[[]]] ];
_radio params ["_radio_object", "_radio_qualifier"];

_radio_object setVariable [_radio_qualifier, + _value, true];

GVAR(VehicleConfigCacheNamespace) setVariable ["lastRadioSettingUpdate",diag_tickTime];
