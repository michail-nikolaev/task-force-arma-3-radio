#include "script_component.hpp"

/*
    Name: TFAR_fnc_GetChannelFrequency

    Author(s):
        L-H

    Description:
        Returns the frequency for the passed channel and radio.

    Parameters:
    0: OBJECT/String - Radio
    1: NUMBER - Channel

    Returns:
    STRING - Frequency

    Example:
    // LR radio - channel 1
    [(call TFAR_fnc_activeLrRadio), 1] call TFAR_fnc_GetChannelFrequency;
    // SW radio - channel 1
    [(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_GetChannelFrequency;
*/

params ["_radio", "_channel"];

private _channel = _channel - 1;
private _settings = nil;

if (_radio isEqualType "") then {
    _settings = _radio call TFAR_fnc_getSwSettings;
} else {
    _settings = _radio call TFAR_fnc_getLrSettings;
};

if (!isNil "_settings") then {
    ((_settings select TF_FREQ_OFFSET) select _channel)
} else {
    "";
};
