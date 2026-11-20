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

// A joining client may already have the server's runtime overrides.
if (!isServer) exitWith {
    [_variableName, missionNamespace getVariable [_variableName, _value]] call TFAR_fnc_storeFrequencyNames;
};

// CBA replays unchanged settings when a save is loaded. Preserve scripted changes.
private _settingKey = _variableName + "_setting";
if (_value isEqualTo (missionNamespace getVariable [_settingKey, false])) exitWith {
    if (isNil {missionNamespace getVariable (_variableName + "_index")}) then {
        [_variableName, missionNamespace getVariable [_variableName, []]] call TFAR_fnc_storeFrequencyNames;
    };
};
missionNamespace setVariable [_settingKey, _value];

private _definitions = [_value, _isLrRadio] call TFAR_fnc_parseFrequencyNamesInput;
if (!isNil QGVAR(pendingFrequencyNames)) then {
    private _pending = GVAR(pendingFrequencyNames) get _variableName;
    if (!isNil "_pending") then {
        _definitions = _definitions select {!((_x select 0) in _pending)};
        private _names = (keys _pending) select {(_pending get _x) isNotEqualTo ""};
        private _overrides = _names apply {[_x, _pending get _x]};
        _definitions resize ((count _definitions) min (TFAR_MAX_FREQUENCY_NAMES - count _overrides));
        _definitions append _overrides;
    };
};
[_variableName, _definitions, true] call TFAR_fnc_storeFrequencyNames;
