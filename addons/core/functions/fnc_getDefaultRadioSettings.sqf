#include "script_component.hpp"

/*
    Name: TFAR_fnc_getDefaultRadioSettings

    Author(s):
        Dorbedo

    Description:
        Return array of default radio classes for player.

    Parameters:
        0: BOOL - is SW radio (Default: true)
        1: Object - the unit (Default: TFAR_currentUnit)

    Returns:
        ARRAY

    Example:
        _swFrequencies =  call TFAR_fnc_getDefaultRadioSettings;
        _lrFrequencies = false call TFAR_fnc_getDefaultRadioSettings;
*/

params [["_isSW", true, [false]], ["_unit", TFAR_currentUnit, [objNull]]];

If (_isSW) then {
    private _value = (group _unit) getVariable "tf_sw_frequency";

    If ((isNil "_value") && {TFAR_SameSRFrequenciesForSide}) then {
        _value = switch (_unit call BIS_fnc_objectSide) do {
            case west : {
                missionNamespace getVariable "TFAR_freq_sr_west";
            };
            case east : {
                missionNamespace getVariable "TFAR_freq_sr_east";
            };
            default {
                missionNamespace getVariable "TFAR_freq_sr_independent";
            };
        };
    };

    if (isNil "_value") then {
        _value = call DFUNC(generateSRSettings);
    };

} else {
    private _value = (group _unit) getVariable "tf_lr_frequency";

    If ((isNil "_value") && {TFAR_SameSRFrequenciesForSide}) then {
        _value = switch (_unit call BIS_fnc_objectSide) do {
            case west : {
                missionNamespace getVariable "TFAR_freq_lr_west";
            };
            case east : {
                missionNamespace getVariable "TFAR_freq_lr_east";
            };
            default {
                missionNamespace getVariable "TFAR_freq_lr_independent";
            };
        };
    };

    if (isNil "_value") then {
        _value = call DFUNC(generateLRSettings);
    };
};

_value
