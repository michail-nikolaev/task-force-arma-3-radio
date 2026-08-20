#include "script_component.hpp"

/*
  Name: TFAR_fnc_setFrequencyName

  Author: Darojax
    Assigns a side-specific name to an SR or LR frequency. This server-side
    mission configuration is broadcast to clients. Names are truncated to the
    supported display length. Pass an empty name to remove the definition.

  Arguments:
    0: Radio side <SIDE>
    1: Is long-range frequency <BOOL>
    2: Frequency <NUMBER|STRING>
    3: Frequency name <STRING>

  Return Value:
    Whether the frequency-name definition was set and broadcast <BOOL>

  Example:
    [west, false, "111", "COY NET"] call TFAR_fnc_setFrequencyName;

  Public: Yes
*/

params [
    ["_side", sideUnknown, [sideUnknown]],
    ["_isLrRadio", false, [false]],
    ["_frequency", "", [0, ""]],
    ["_name", "", [""]]
];

if (!isServer || {!(_side in [west, east, independent])}) exitWith {false};

private _frequencyString = if (_frequency isEqualType "") then {_frequency} else {str _frequency};
if (_frequencyString isEqualTo "") exitWith {false};

_name = _name select [0, TFAR_MAX_CHANNEL_NAME_LENGTH];

private _radioType = ["sr", "lr"] select _isLrRadio;
private _sideName = switch (_side) do {
    case west: {"west"};
    case east: {"east"};
    default {"independent"};
};
private _variableName = format ["TFAR_frequencyNames_%1_%2", _radioType, _sideName];
private _frequencyNumber = TFAR_FREQUENCYSTRING_TO_FREQNUMBER(_frequencyString);
private _frequencyNames = +(missionNamespace getVariable [_variableName, []]);
private _definitionIndex = _frequencyNames findIf {
    _x isEqualType [] &&
    {count _x >= 2} &&
    {
        private _definedFrequency = _x param [0, "", [0, ""]];
        private _definedFrequencyString = if (_definedFrequency isEqualType "") then {_definedFrequency} else {str _definedFrequency};
        _definedFrequencyString isNotEqualTo "" &&
        {TFAR_FREQUENCYSTRING_TO_FREQNUMBER(_definedFrequencyString) == _frequencyNumber}
    }
};

private _oldName = "";
if (_definitionIndex >= 0) then {
    _oldName = (_frequencyNames select _definitionIndex) param [1, "", [""]];
};

if (_name isNotEqualTo "" && {_definitionIndex < 0} && {count _frequencyNames >= TFAR_MAX_FREQUENCY_NAMES}) exitWith {false};

if (_name isEqualTo "") then {
    if (_definitionIndex >= 0) then {
        _frequencyNames deleteAt _definitionIndex;
    };
} else {
    if (_definitionIndex >= 0) then {
        _frequencyNames set [_definitionIndex, [_frequencyString, _name]];
    } else {
        _frequencyNames pushBack [_frequencyString, _name];
    };
};

missionNamespace setVariable [_variableName, _frequencyNames, true];
["OnFrequencyNameChanged", [_side, _isLrRadio, _frequencyString, _oldName, _name]] call TFAR_fnc_fireEventHandlers;

true
