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
        2: STRING - the radiotype (only for LR and the usage of group defined radio settings needed)

    Returns:
        ARRAY

    Example:
        _swFrequencies =  call TFAR_fnc_getDefaultRadioSettings;
        _lrFrequencies = false call TFAR_fnc_getDefaultRadioSettings;
*/

params [["_isSW", true, [false]], ["_unit", TFAR_currentUnit, [objNull]]];

if (_isSW) then {
    private _value = (group _unit) getVariable "TFAR_freq_sr";

    if ((isNil "_value") && {TFAR_SameSRFrequenciesForSide}) then {
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
    private _lrRadioType = _this param [2,""];

    private _value = if (
            (!(_lrRadioType isEqualTo "")) &&
            (getText(configFile >> "CfgVehicles" >> _radioType >> "tf_encryptionCode") == toLower (format ["tf_%1_radio_code",(_unit call BIS_fnc_objectSide)]))
        ) then {
            (group _unit) getVariable "TFAR_freq_lr";
        } else {
            nil
        };

    if ((isNil "_value") && {TFAR_SameSRFrequenciesForSide}) then {
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
