#include "script_component.hpp"

/*
  Name: TFAR_fnc_setFrequencyName

  Author: Darojax
    Assigns a side-specific name to an SR or LR frequency. This server-side
    mission configuration is broadcast to clients. Names are truncated to the
    supported display length. Pass an empty name to remove the definition.
    Frequencies use normal radio tuning precision. Successful calls made before
    CBA settings initialization take precedence over the initial CBA definitions;
    CBA definitions fill any remaining slots. Later CBA edits replace the table.

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

private _frequencyString = [_frequency, _isLrRadio] call TFAR_fnc_normalizeFrequency;
if (_frequencyString isEqualTo "") exitWith {false};

if (count _name > TFAR_MAX_CHANNEL_NAME_LENGTH) then {_name = _name select [0, TFAR_MAX_CHANNEL_NAME_LENGTH]};

private _variableName = TFAR_FREQUENCY_NAMES_VAR(_side,_isLrRadio);
// Scheduled mission scripts must see each other's completed table changes.
private _accepted = false;
private _oldName = "";
isNil {
    private _definitions = +(missionNamespace getVariable [_variableName, []]);
    if (_definitions isNotEqualTo [] && {isNil {missionNamespace getVariable (_variableName + "_index")}}) then {
        _definitions = [_definitions, _isLrRadio] call TFAR_fnc_parseFrequencyNamesInput;
    };
    private _index = _definitions findIf {(_x select 0) isEqualTo _frequencyString};
    if (_index < 0 && {_name isNotEqualTo ""} && {count _definitions >= TFAR_MAX_FREQUENCY_NAMES}) exitWith {nil};

    if (_index >= 0) then {
        _oldName = (_definitions select _index) select 1;
        if (_name isEqualTo "") then {
            _definitions deleteAt _index;
        } else {
            _definitions set [_index, [_frequencyString, _name]];
        };
    } else {
        if (_name isNotEqualTo "") then {_definitions pushBack [_frequencyString, _name]};
    };

    // A removal before CBA applies its initial setting must also override that setting.
    if (!isNil QGVAR(pendingFrequencyNames)) then {
        if !(_variableName in GVAR(pendingFrequencyNames)) then {
            GVAR(pendingFrequencyNames) set [_variableName, createHashMap];
        };
        private _pending = GVAR(pendingFrequencyNames) get _variableName;
        _pending set [_frequencyString, _name];
    };

    [_variableName, _definitions, true] call TFAR_fnc_storeFrequencyNames;
    _accepted = true;
    nil
};
if (_accepted) then {
    ["OnFrequencyNameChanged", [_side, _isLrRadio, _frequencyString, _oldName, _name]] call TFAR_fnc_fireEventHandlers;
};
_accepted
