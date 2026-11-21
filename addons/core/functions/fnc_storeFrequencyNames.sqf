#include "script_component.hpp"

// Keep the ordered pair list for mission scripts and index it once for fast reads.
params ["_variableName", "_definitions", ["_publish", false]];
if (!_publish) then {
    // Also accept saved or replicated lists written by older named-channel builds.
    _definitions = [_definitions, (_variableName find "_lr_") >= 0] call TFAR_fnc_parseFrequencyNamesInput;
};
missionNamespace setVariable [_variableName, _definitions];
missionNamespace setVariable [_variableName + "_index", createHashMapFromArray _definitions];

if (_publish) then {
    // Reusing the ID keeps only the latest snapshot for each side and band.
    ["TFAR_frequencyNamesChanged", [_variableName, _definitions], _variableName] call CBA_fnc_globalEventJIP;
};
if (hasInterface) then {call TFAR_fnc_refreshRadioDialogFrequency};
