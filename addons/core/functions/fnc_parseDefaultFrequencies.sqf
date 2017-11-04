#include "script_component.hpp"

/*
    Name: TFAR_fnc_parseDefaultFrequencies

    Author(s):
        Dorbedo

    Description:
        parses the default frequencies

    Parameters:
        STRING: the default value variable
        STRING: cba_setting value

    Returns:
        NOTHING

    Example:
        ["TFAR_defaultFrequencies_lr_west","[50,51,52,53,54,55,56,57,58,59]"] call TFAR_fnc_parseDefaultFrequencies;
*/

If !(isServer) exitWith {};

params [["_settingName", "", [""]], ["_valueString", "" ,[""]]];

If (_settingName isEqualTo "") exitWith {};

If !(((_valueString find "[") isEqualTo 0) && {(_valueString find "]") isEqualTo ((count _valueString) + 1)}) then {
    _valueString = format["[%1]",_valueString];
};

private _parsedValue = ((parseSimpleArray _valueString) select {_x isEqualType 0}) apply {parseNumber(_x toFixed 1)};

If ((_settingName find "sr")>0) then {
    If !(({(_x >= TFAR_MIN_SW_FREQ)&&(_x <= TFAR_MAX_SW_FREQ)} count _parsedValue) isEqualTo TFAR_MAX_CHANNELS) then {
        _parsedValue = [TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
    } else {
        (_parsedValue resize TFAR_MAX_CHANNELS) apply {str _x};
    };
    missionNamespace setVariable [_settingName, _parsedValue, true];
} else {
    If !(({(_x >= TFAR_MIN_ASIP_FREQ)&&(_x <= TFAR_MAX_ASIP_FREQ)} count _parsedValue) isEqualTo TFAR_MAX_LR_CHANNELS) then {
        _parsedValue = [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
    } else {
        (_parsedValue resize TFAR_MAX_LR_CHANNELS) apply {str _x};
    };
    missionNamespace setVariable [_settingName, _parsedValue, true];
};
