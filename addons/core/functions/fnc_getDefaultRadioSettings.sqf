#include "script_component.hpp"

/*
    Name: TFAR_fnc_getDefaultRadioSettings

    Author(s):
        Dorbedo

    Description:
        Return array of default radio classes for player.
        The order is:
            1. User-specific frequencies (for LR, an radio with the side-encryptionCode is needed)
            2. Group-specific frequencies (for LR, an radio with the side-encryptionCode is needed)
            3. Side-specific frequencies (if same Frequencies for side is enabled)
            4. Randomized frequencies

    Parameters:
        0: BOOL - is SW radio (Default: true)
        1: Object - the unit (Default: TFAR_currentUnit)
        2: STRING - the radiotype (only for LR and the usage of group defined radio settings needed)

    Returns:
        ARRAY

    Example:
        _swFrequencies = true call TFAR_fnc_getDefaultRadioSettings;
        _lrFrequencies = false call TFAR_fnc_getDefaultRadioSettings;
*/

params [["_isSW", true, [false]], ["_unit", TFAR_currentUnit, [objNull]]];

if (_isSW) then {

    private _defFreq = _unit getVariable "TFAR_freq_sr";
    if (isNil "_defFreq") then {
        _defFreq = (group _unit) getVariable "TFAR_freq_sr";
    };

    If !(isNil "_defFreq") exitWith {
        private _return = false call DFUNC(generateSRSettings);
        _return set [2,_defFreq];
        _return
    };
    
    private _return = if (TFAR_SameSRFrequenciesForSide) then {
        switch (_unit call BIS_fnc_objectSide) do {
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
    } else {
        nil
    };

    if (isNil "_value") then {
        _value = [] call DFUNC(generateSRSettings);
    };

    _value

} else {

    private _encryptionCode = [(_this param [2, "", [""]]), "tf_encryptionCode"] call DFUNC(getConfigProperty);

    private _value = nil;

    if (_encryptionCode == (format ["tf_%1_radio_code", (_unit call BIS_fnc_objectSide)])) then {
        private _defFreq = _unit getVariable "TFAR_freq_sr";

        if (isNil "_defFreq") then {
            _defFreq = (group _unit) getVariable "TFAR_freq_sr";
        };
        
        If !(isNil "_defFreq") then {
            _value = false call DFUNC(generateLRSettings);
            _value set [2,_defFreq];
        };
    };

    if ((isNil "_value") && {TFAR_SameSRFrequenciesForSide}) then {
        switch (_unit call BIS_fnc_objectSide) do {
            case west : {
                _value = missionNamespace getVariable "TFAR_freq_lr_west";
            };
            case east : {
                _value = missionNamespace getVariable "TFAR_freq_lr_east";
            };
            default {
                _value = missionNamespace getVariable "TFAR_freq_lr_independent";
            };
        };
    };

    if (isNil "_value") then {
        _value = true call DFUNC(generateLRSettings);
    };

    _value

};
