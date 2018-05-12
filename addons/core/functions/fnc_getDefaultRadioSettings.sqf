#include "script_component.hpp"

/*
  Name: TFAR_fnc_getDefaultRadioSettings

  Author: Dorbedo
    Return array of default radio classes for player.
    The order is:
    1. User-specific frequencies (for LR, an radio with the side-encryptionCode is needed)
    2. Group-specific frequencies (for LR, an radio with the side-encryptionCode is needed)
    3. Side-specific frequencies (if same Frequencies for side is enabled)
    4. Randomized frequencies

  Arguments:
    0: is SR radio <BOOL> (Default: true)
    1: the unit (Default: TFAR_currentUnit) <OBJECT> (Default: TFAR_currentUnit)
    2: the radiotype (only for LR and the usage of group defined radio settings needed) <STRING>

  Return Value:
    default settings <TYPENAME>

  Example:
    _SRSettings = true call TFAR_fnc_getDefaultRadioSettings;
    _LRSettings = false call TFAR_fnc_getDefaultRadioSettings;

  Public: Yes
*/

params [
    ["_isSW", true, [false]],
    ["_unit", TFAR_currentUnit, [objNull]],
    ["_radioclass", "", [""]]
];

private "_return";

if (_isSW) then {

    private _frequencies = _unit getVariable ["TFAR_freq_sr", (group _unit) getVariable "TFAR_freq_sr"];

    if (TFAR_SameSRFrequenciesForSide) && {isNil "_frequencies"} then {
        _return = switch (_unit call BIS_fnc_objectSide) do {
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
        if (isNil "_value") then {
            _return = false call DFUNC(generateSRSettings);
            _return set [2, _frequencies];
        } else {
            _return = true call DFUNC(generateSRSettings);
        };
    };

    private _encryptionCode = [_radioclass, "tf_encryptionCode", ""] call DFUNC(getWeaponConfigProperty);
    if (_encryptionCode == "tf_guer_radio_code") then {_encryptionCode = "tf_independent_radio_code"};

    _return set [TFAR_CODE_OFFSET, _encryptionCode];

} else {

    private _frequencies = _unit getVariable ["TFAR_freq_lr", (group _unit) getVariable "TFAR_freq_lr"];

    if (TFAR_SameLRFrequenciesForSide) && {isNil "_frequencies"} then {
        _return = switch (_unit call BIS_fnc_objectSide) do {
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
    } else {
        if (isNil "_value") then {
            _return = false call DFUNC(generateLRSettings);
            _return set [2, _frequencies];
        } else {
            _return = true call DFUNC(generateLRSettings);
        };
    };

    private _encryptionCode = [_radioclass, "tf_encryptionCode", ""] call DFUNC(getVehicleConfigProperty);
    if (_encryptionCode == "tf_guer_radio_code") then {_encryptionCode = "tf_independent_radio_code"};

    _return set [TFAR_CODE_OFFSET, _encryptionCode];

};

_return
