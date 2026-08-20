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
    missionNamespace setVariable [_variableName, _definitions, true];
} else {
    if (isNil {missionNamespace getVariable _variableName}) then {
        missionNamespace setVariable [_variableName, _definitions];
    };
};
