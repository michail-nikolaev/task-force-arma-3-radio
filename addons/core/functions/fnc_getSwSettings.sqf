#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwSettings

    Author(s):
        NKey
        L-H

    Description:
        Returns the current settings for the passed radio.

    Parameters:
    0: String - Radio classname

    Returns:
    ARRAY - settings.

    Example:
    (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSettings;
*/
params[["_radio","",[""]]];

private _value = TFAR_RadioSettingsNamespace getVariable _radio;
if (!isNil "_value") exitWith {_value};



if (!(TF_use_saved_sw_setting) or (isNil "TF_saved_active_sw_settings")) then {
    private _defaultRadios = call TFAR_fnc_getDefaultRadioClasses;
    private _parent = getText (configFile >> "CfgWeapons" >> _radio >> "tf_parent");
    if ((_defaultRadios select 1) == _parent or {(_defaultRadios select 2) == _parent}) then {
        _value = (group TFAR_currentUnit) getVariable "tf_sw_frequency";
    };
    if (isNil "_value") then {
        _value = call TFAR_fnc_generateSRSettings;
    };
} else {
    _value = TF_saved_active_sw_settings;
};

if (TF_use_saved_sw_setting) then {
    TF_use_saved_sw_setting = false;
};
//If value doesn't have Radio code set.. Add it //#TODO why can this even happen? //generateXXSettings sets nil as radiocode
private _rc = _value select TFAR_CODE_OFFSET;
if (isNil "_rc") then {
    _rc = "";
    private _code = getText (configFile >>  "CfgWeapons" >> _radio >> "tf_encryptionCode");
    private _hasDefaultEncryption = (_code == "tf_west_radio_code") or {_code == "tf_east_radio_code"} or {_code == "tf_independent_radio_code"};
    if (_hasDefaultEncryption and {!isServer} and {(TFAR_currentUnit call BIS_fnc_objectSide) != civilian}) then {
        _parent = getText (configFile >> "CfgWeapons" >> _radio >> "tf_parent");
        private _default = call TFAR_fnc_getDefaultRadioClasses;
        if ((_default select 1) == _parent or {(_default select 2) == _parent}) then {
            _rc = missionNamespace getVariable format ["tf_%1_radio_code", (TFAR_currentUnit call BIS_fnc_objectSide)];
        } else {
            _rc = missionNamespace getVariable [_code, ""];
        };
    } else {
        _rc = "";
        if (_code != "") then {
            _rc = missionNamespace getVariable [_code, ""];
        };
    };
    _value set [TFAR_CODE_OFFSET, _rc];
};

[_radio, _value, true] call TFAR_fnc_setSwSettings;



_value
