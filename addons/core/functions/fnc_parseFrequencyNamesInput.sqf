#include "script_component.hpp"

/*
  Name: TFAR_fnc_parseFrequencyNamesInput

  Author: Darojax
    Parses a comma-separated list of frequency=name definitions.

  Arguments:
    0: Comma-separated definitions or saved frequency/name pairs <STRING|ARRAY>
    1: Is long-range frequency list <BOOL>

  Return Value:
    Valid frequency-name definitions, limited to 16 entries <ARRAY>

  Example:
    ["111=COY NET,222=1/2 SEC", false] call TFAR_fnc_parseFrequencyNamesInput;

  Public: Yes
*/

params [
    ["_input", "", ["", []]],
    ["_isLrRadio", false, [false]]
];

private _pairs = _input;
if (_input isEqualType "") then {
    _pairs = (_input splitString ",") apply {
        private _separator = _x find "=";
        if (_separator < 1) then {[]} else {
            [_x select [0, _separator], [_x select [_separator + 1]] call CBA_fnc_trim]
        }
    };
};

private _definitions = [];
{
    if (_x isEqualTypeParams ["", ""] || {_x isEqualTypeParams [0, ""]}) then {
        _x params ["_frequency", "_name"];
        _frequency = [_frequency, _isLrRadio] call TFAR_fnc_normalizeFrequency;
        if (_frequency isNotEqualTo "" && {_name isNotEqualTo ""}) then {
            private _index = _definitions findIf {(_x select 0) isEqualTo _frequency};
            if (_index >= 0 || {count _definitions < TFAR_MAX_FREQUENCY_NAMES}) then {
                if (_index < 0) then {_index = count _definitions};
                _definitions set [_index, [_frequency, _name select [0, TFAR_MAX_CHANNEL_NAME_LENGTH]]];
            };
        };
    };
} forEach _pairs;
_definitions
