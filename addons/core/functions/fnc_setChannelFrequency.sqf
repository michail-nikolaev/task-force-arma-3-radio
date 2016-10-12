#include "script_component.hpp"

/*
    Name: TFAR_fnc_SetChannelFrequency

    Author(s):
        L-H

    Description:
        Sets the frequency for the channel on the passed radio.

    Parameters:
    0: OBJECT/String - Radio
    1: NUMBER - Channel
    2: STRING - Frequency

    Returns:
    Nothing

    Example:
    // LR radio - channel 1
    [(call TFAR_fnc_activeLrRadio), 1, "56.2"] call TFAR_fnc_SetChannelFrequency;
    // SW radio - channel 1
    [(call TFAR_fnc_activeSwRadio), 1, "84.3"] call TFAR_fnc_SetChannelFrequency;
*/

params ["_radio", "_channel", "_frequency"];
_channel = _channel - 1;

private _lr = if (_radio isEqualType "") then { false }else{true};
private _settings = nil;

if (_lr) then {
    _settings = _radio call TFAR_fnc_getLrSettings;
} else {
    _settings = _radio call TFAR_fnc_getSwSettings;
};

if (isNil "_settings") exitWith {};

(_settings select TF_FREQ_OFFSET) set [_channel, _frequency];

if (_lr) then {
    [_radio select 0, _radio select 1, _settings] call TFAR_fnc_setLrSettings;
} else {
    [_radio, _settings] call TFAR_fnc_setSwSettings;
};
