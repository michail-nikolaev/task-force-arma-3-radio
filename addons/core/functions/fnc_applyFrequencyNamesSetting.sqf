#include "script_component.hpp"

/*
  Name: TFAR_fnc_applyFrequencyNamesSetting

  Author: Darojax
    Parses a CBA frequency-name setting and publishes its canonical table.

  Arguments:
    0: CBA setting value <STRING>
    1: Canonical mission namespace variable <STRING>
    2: Is long-range frequency list <BOOL>

  Return Value:
    None

  Public: No
*/

params [
    ["_value", "", [""]],
    ["_variableName", "", [""]],
    ["_isLrRadio", false, [false]]
];

if (_variableName isEqualTo "") exitWith {};

private _definitions = [_value, _isLrRadio] call TFAR_fnc_parseFrequencyNamesInput;
if (isServer) then {
    private _pendingVariable = _variableName + "_pending";
    private _pending = missionNamespace getVariable [_pendingVariable, []];
    private _pendingFrequencies = _pending apply {_x select 0};
    _definitions = _definitions select {!((_x select 0) in _pendingFrequencies)};
    private _namedOverrides = _pending select {(_x select 1) isNotEqualTo ""};
    // Honor already accepted scripted names even when CBA supplies a full table.
    _definitions resize ((count _definitions) min (TFAR_MAX_FREQUENCY_NAMES - count _namedOverrides));
    _definitions append _namedOverrides;
    if (missionNamespace getVariable [QGVAR(SettingsInitialized), false]) then {
        missionNamespace setVariable [_pendingVariable, nil];
    };

    missionNamespace setVariable [_variableName, _definitions, true];
    ["TFAR_frequencyNamesChanged", [_variableName, _definitions]] call CBA_fnc_globalEvent;
} else {
    if (isNil {missionNamespace getVariable _variableName}) then {
        missionNamespace setVariable [_variableName, _definitions];
    };
};
