#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwSettings

    Author(s):
        NKey

    Description:
        Saves the settings for the passed radio and broadcasts it to all clients and the server.

    Parameters:
        0: STRING - Radio classname
        1: ARRAY - Settings, usually acquired via TFAR_fnc_getSwSettings and then changed.
        2: BOOLEAN - Set local only

    Returns:
        Nothing

    Example:
        _settings = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
        _settings set [0, 2]; // sets the active channel to 2
        [call TFAR_fnc_activeSwRadio, _settings] call TFAR_fnc_setSwSettings;
*/

params ["_radio_id", "_value", ["_local", false, [true]]];

private _variableName = format["%1_settings", _radio_id];

missionNamespace setVariable [_variableName, + _value,!_local];
missionNamespace setVariable [_variableName + "_local", + _value];
