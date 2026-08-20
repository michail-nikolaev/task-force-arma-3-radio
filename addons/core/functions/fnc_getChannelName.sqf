#include "script_component.hpp"

/*
  Name: TFAR_fnc_getChannelName

  Author: Darojax
    Returns the name assigned to a radio channel's current frequency. Channel
    numbers do not own names; this is a convenience wrapper around
    TFAR_fnc_getFrequencyName.

  Arguments:
    0: Radio <ARRAY|STRING>
    1: 1-based channel number <NUMBER>

  Return Value:
    Frequency name, or an empty string if no name is assigned <STRING>

  Example:
    [(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_getChannelName;

  Public: Yes
*/

params [
    ["_radio", "", [[], ""]],
    ["_channel", 1, [0]]
];

private _isLrRadio = _radio isEqualType [];
private _maxChannels = [TFAR_MAX_CHANNELS, TFAR_MAX_LR_CHANNELS] select _isLrRadio;
if (_channel < 1 || {_channel > _maxChannels}) exitWith {""};

private _frequency = [_radio, _channel] call TFAR_fnc_getChannelFrequency;
[_radio, _frequency] call TFAR_fnc_getFrequencyName
