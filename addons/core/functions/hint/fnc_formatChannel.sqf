#include "script_component.hpp"

/*
  Name: TFAR_fnc_formatChannel

  Author: Darojax
    Formats a channel number and its optional name for structured-text hints.

  Arguments:
    0: Radio <ARRAY|STRING>
    1: 1-based channel number <NUMBER>
    2: Transmitted frequency, when known <STRING> (optional)

  Return Value:
    Channel number, optionally followed by its escaped name <STRING>

  Example:
    [(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_formatChannel;

  Public: No
*/

params [
    ["_radio", "", [[], ""]],
    ["_channel", 1, [0]],
    ["_frequency", "", [""]]
];

private _channelName = if (_frequency isEqualTo "") then {
    [_radio, _channel] call TFAR_fnc_getChannelName
} else {
    [_radio, _frequency] call TFAR_fnc_getFrequencyName
};
if (_channelName isEqualTo "") exitWith {str _channel};

_channelName = [_channelName, "&", "&amp;"] call CBA_fnc_replace;
_channelName = [_channelName, "<", "&lt;"] call CBA_fnc_replace;
_channelName = [_channelName, ">", "&gt;"] call CBA_fnc_replace;

format ["%1 - %2", _channel, _channelName]
