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
        _radioType = [typeof _radio_object, "tf_RadioType"] call TFAR_fnc_getVehicleConfigProperty;
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


if (isNil QGVAR(saved_active_lr_settings)) then {
    _value = false call DFUNC(getDefaultRadioSettings)
} else {
    _value = GVAR(saved_active_lr_settings);
    GVAR(saved_active_lr_settings) = nil;
};


private _radioCode = _value select TFAR_CODE_OFFSET;
if (isNil "_radioCode") then {
    _radioCode = "";
    private _code = [_radio_object, "tf_encryptionCode"] call TFAR_fnc_getLrRadioProperty;
    if (_code == "tf_guer_radio_code") then {_code = "tf_independent_radio_code"};
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

[[_radio_object, _radio_id], + _value] call TFAR_fnc_setLrSettings;

//Internal use only.. For assigning Curator Logics frequencies
["newLRSettingsAssigned", [player, [_radio_object,_radio_id]]] call TFAR_fnc_fireEventHandlers;

_value
