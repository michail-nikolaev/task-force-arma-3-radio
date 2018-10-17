#include "script_component.hpp"

/*
  Name: TFAR_fnc_setChannelFrequency

  Author: Garth de Wet (L-H)
    Sets the frequency for the channel on the passed radio.

  Arguments:
    0: Radio <OBJECT|STRING>
    1: 1-based Channel number <NUMBER>
    2: Frequency <STRING>

  Return Value:
    None

  Example:
    // LR radio - channel 1
    [(call TFAR_fnc_activeLrRadio), 1, "56.2"] call TFAR_fnc_setChannelFrequency;
    // SW radio - channel 1
    [(call TFAR_fnc_activeSwRadio), 1, "84.3"] call TFAR_fnc_setChannelFrequency;

  Public: Yes
*/

params [["_radio","",[[],""]], "_channel", "_frequency"];
_channel = _channel - 1;

private _isLRRadio = _radio isEqualType [];
private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLRRadio);

if (isNil "_settings") exitWith {};

private _oldFrequency = (_settings select TFAR_FREQ_OFFSET) param [_channel, 0];

(_settings select TFAR_FREQ_OFFSET) set [_channel, _frequency];

["OnFrequencyChanged", [TFAR_currentUnit, _radio, _channel, _oldFrequency, _frequency]] call TFAR_fnc_fireEventHandlers;

[_radio, _settings] call ([TFAR_fnc_setSwSettings, TFAR_fnc_setLrSettings] select _isLRRadio);
