#include "script_component.hpp"

/*
    Name: TFAR_fnc_getLrSettings

    Author(s):
        NKey
        L-H

    Description:
        Returns the current settings for the passed radio.

    Parameters:
        0: OBJECT - Radio object
        1: STRING - Radio ID

    Returns:
        ARRAY - settings.

    Example:
        (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;
*/
params ["_radio_object", "_radio_id"];

private _value = _radio_object getVariable _radio_id;
if (!isNil "_value") exitWith {_value};

private _radioType = "";
if (_radio_object isKindOf "Bag_Base") then {
    _radioType = typeof _radio_object;
} else {
    _radioType = _radio_object getVariable "TF_RadioType";
    if (isNil "_radioType") then {
        _radioType = [typeof _radio_object, "tf_RadioType"] call TFAR_fnc_getConfigProperty;
        if ((isNil "_radioType") or {_radioType == ""}) then {
            private _isAirRadio = (typeof(_radio_object) isKindOf "Air");

            switch (_radio call TFAR_fnc_getVehicleSide) do {
                case west: {
                    _radioType = [TFAR_DefaultRadio_Backpack_West,TFAR_DefaultRadio_Airborne_West] select _isAirRadio;
                };
                case east: {
                    _radioType = [TFAR_DefaultRadio_Backpack_East,TFAR_DefaultRadio_Airborne_East] select _isAirRadio;
                };
                default {
                    _radioType = [TFAR_DefaultRadio_Backpack_Independent,TFAR_DefaultRadio_Airborne_Independent] select _isAirRadio;
                };
            };
        };
    };
};


if (!(TF_use_saved_lr_setting) or (isNil "TF_saved_active_lr_settings")) then {
    if (((call TFAR_fnc_getDefaultRadioClasses select 0) == _radioType) or {(call TFAR_fnc_getDefaultRadioClasses select 3) == _radioType} or {getText(configFile >> "CfgVehicles" >> _radioType >> "tf_encryptionCode") == toLower (format ["tf_%1_radio_code",(TFAR_currentUnit call BIS_fnc_objectSide)])}) then {
        _value = (group TFAR_currentUnit) getVariable "tf_lr_frequency";
    };
    if (isNil "_value") then {
        _value = [] call TFAR_fnc_generateLrSettings;
    };
} else {
    _value = TF_saved_active_lr_settings;
};

if (TF_use_saved_lr_setting) then {
    TF_use_saved_lr_setting = false;
};

private _radioCode = _value select TFAR_CODE_OFFSET;
if (isNil "_radioCode") then {
    _radioCode = "";
    private _code = [_radio_object, "tf_encryptionCode"] call TFAR_fnc_getLrRadioProperty;
    private _hasDefaultEncryption = (_code == "tf_west_radio_code") or {_code == "tf_east_radio_code"} or {_code == "tf_independent_radio_code"};
    if (_hasDefaultEncryption and {!isServer} and {((TFAR_currentUnit call BIS_fnc_objectSide) != civilian)}) then {
        if (((call TFAR_fnc_getDefaultRadioClasses select 0) == _radioType) or {(call TFAR_fnc_getDefaultRadioClasses select 3) == _radioType} or {_radio_object call TFAR_fnc_getVehicleSide == TFAR_currentUnit call BIS_fnc_objectSide}) then {
            _radioCode = missionNamespace getVariable format ["tf_%1_radio_code",(TFAR_currentUnit call BIS_fnc_objectSide)];
        } else {
            _radioCode = missionNamespace getVariable [_code, ""];
        };
    } else {
        _radioCode = "";
        if (_code != "") then {
            _radioCode = missionNamespace getVariable [_code, ""];
        };
    };
    _value set [TFAR_CODE_OFFSET, _radioCode];
};

private _halfDuplexOverride = _value select HALFDUPLEX_OVERRIDE_OFFSET;
if (isNil "_halfDuplexOverride") then {
    _halfDuplexOverride = false; // TODO MorpheusXAUT load default from config?
    _value set [HALFDUPLEX_OVERRIDE_OFFSET, _halfDuplexOverride];
};

[[_radio_object, _radio_id], + _value] call TFAR_fnc_setLrSettings;

//Internal use only.. For assigning Curator Logics frequencies
["newLRSettingsAssigned", [player, [_radio_object,_radio_id]]] call TFAR_fnc_fireEventHandlers;

_value
