#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getChannelFrequency
 *
 * Author: L-H
 * Returns the frequency for the passed channel and radio.
 *
 * Arguments:
 * 0: Radio <OBJECT/STRING>
 *
 * Return Value:
 * Frequency <STRING>
 *
 * Example:
 *      // LR radio - channel 1
 *      [(call TFAR_fnc_activeLrRadio), 1] call TFAR_fnc_getChannelFrequency;
 *      // SW radio - channel 1
 *      [(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_getChannelFrequency;
 *
 * Public: Yes
 */

params ["_radio", "_channel"];

private _channel = _channel - 1;
private _settings = nil;

if (_radio isEqualType "") then {//SW radio is string
    _settings = _radio call TFAR_fnc_getSwSettings;
} else {//LR Radio is array
    _settings = _radio call TFAR_fnc_getLrSettings;
};



((_settings param[TFAR_FREQ_OFFSET]) param [_channel,""])
