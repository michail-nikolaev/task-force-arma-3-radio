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

private _radioSide = _radio call TFAR_fnc_getRadioSide;
if !(_radioSide in [west, east, independent]) exitWith {""};

private _isLrRadio = _radio isEqualType [];
private _variableName = TFAR_FREQUENCY_NAMES_VAR(_radioSide,_isLrRadio);
private _names = missionNamespace getVariable (_variableName + "_index");
if (isNil "_names" || {count _names == 0}) exitWith {""};

// Frequencies supplied by the radio are already in canonical form.
if (_frequency in _names) exitWith {_names get _frequency};
private _frequencyString = [_frequency, _isLrRadio] call TFAR_fnc_normalizeFrequency;
_names getOrDefault [_frequencyString, ""]
