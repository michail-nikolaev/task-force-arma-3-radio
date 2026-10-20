#include "script_component.hpp"

/*
  Name: TFAR_fnc_getFrequencyName

  Author: Darojax
    Returns the side-specific name assigned to a radio frequency.

  Arguments:
    0: Radio <ARRAY|STRING>
    1: Frequency <NUMBER|STRING>

  Return Value:
    Frequency name, or an empty string if no name is assigned <STRING>

  Example:
    [(call TFAR_fnc_activeSwRadio), "111"] call TFAR_fnc_getFrequencyName;

  Public: Yes
*/

params [
    ["_radio", "", [[], ""]],
    ["_frequency", "", [0, ""]]
];

private _isLrRadio = _radio isEqualType [];
private _frequencyString = [_frequency, _isLrRadio] call TFAR_fnc_normalizeFrequency;
if (_frequencyString isEqualTo "") exitWith {""};

private _radioSide = _radio call TFAR_fnc_getRadioSide;
if !(_radioSide in [west, east, independent]) exitWith {""};

private _radioType = ["sr", "lr"] select _isLrRadio;
private _sideName = switch (_radioSide) do {
    case west: {"west"};
    case east: {"east"};
    default {"independent"};
};

private _frequencyNames = missionNamespace getVariable [format ["TFAR_frequencyNames_%1_%2", _radioType, _sideName], []];
private _definitionIndex = _frequencyNames findIf {
    _x isEqualType [] &&
    {count _x >= 2} &&
    {
        private _definedFrequency = _x param [0, "", [0, ""]];
        ([_definedFrequency, _isLrRadio] call TFAR_fnc_normalizeFrequency) isEqualTo _frequencyString
    }
};

if (_definitionIndex < 0) exitWith {""};

((_frequencyNames select _definitionIndex) param [1, "", [""]]) select [0, TFAR_MAX_CHANNEL_NAME_LENGTH]
