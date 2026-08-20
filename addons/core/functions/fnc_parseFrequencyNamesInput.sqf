#include "script_component.hpp"

/*
  Name: TFAR_fnc_parseFrequencyNamesInput

  Author: Darojax
    Parses a comma-separated list of frequency=name definitions.

  Arguments:
    0: Frequency-name definitions <STRING>
    1: Is long-range frequency list <BOOL>

  Return Value:
    Valid frequency-name definitions, limited to 16 entries <ARRAY>

  Example:
    ["111=COY NET,222=1/2 SEC", false] call TFAR_fnc_parseFrequencyNamesInput;

  Public: Yes
*/

params [
    ["_input", "", [""]],
    ["_isLrRadio", false, [false]]
];

private _trimString = {
    private _characters = toArray _this;
    while {count _characters > 0 && {(_characters select 0) <= 32}} do {
        _characters deleteAt 0;
    };
    while {count _characters > 0 && {(_characters select (count _characters - 1)) <= 32}} do {
        _characters deleteAt (count _characters - 1);
    };
    toString _characters
};

private _minimumFrequency = [TFAR_MIN_SW_FREQ, TFAR_MIN_ASIP_FREQ] select _isLrRadio;
private _maximumFrequency = [TFAR_MAX_SW_FREQ, TFAR_MAX_ASIP_FREQ] select _isLrRadio;
private _definitions = [];

{
    private _separatorIndex = _x find "=";
    if (_separatorIndex > 0) then {
        private _frequencyString = (_x select [0, _separatorIndex]) call _trimString;
        private _name = (_x select [_separatorIndex + 1]) call _trimString;
        private _frequency = TFAR_FREQUENCYSTRING_TO_FREQNUMBER(_frequencyString);

        if (
            _frequencyString isNotEqualTo "" &&
            {_name isNotEqualTo ""} &&
            {_frequency >= _minimumFrequency} &&
            {_frequency <= _maximumFrequency}
        ) then {
            _name = _name select [0, TFAR_MAX_CHANNEL_NAME_LENGTH];
            private _definitionIndex = _definitions findIf {
                TFAR_FREQUENCYSTRING_TO_FREQNUMBER(_x select 0) == _frequency
            };

            if (_definitionIndex >= 0) then {
                _definitions set [_definitionIndex, [_frequencyString, _name]];
            } else {
                if (count _definitions < TFAR_MAX_FREQUENCY_NAMES) then {
                    _definitions pushBack [_frequencyString, _name];
                };
            };
        };
    };
} forEach (_input splitString ",");

_definitions
