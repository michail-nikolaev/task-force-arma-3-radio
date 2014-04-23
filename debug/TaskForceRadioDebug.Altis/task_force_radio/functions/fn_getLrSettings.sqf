/*
 	Name: TFAR_fnc_getLrSettings
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
		Returns the current settings for the passed radio.
 	
 	Parameters: 
 	0: OBJECT - Radio
	1: STRING - Radio Qualifier
 	
 	Returns:
	ARRAY - settings.
 	
 	Example:
	(call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSettings;
*/
#include "script.h"
private ["_radio_object", "_radio_qualifier", "_value", "_rc"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _radio_object getVariable _radio_qualifier;
if (isNil "_value") then {
	if (!(TF_use_saved_lr_setting) or (isNil "TF_saved_active_lr_settings")) then {
		if ((call TFAR_fnc_getDefaultRadioClasses select 0) == (typeof _radio_object)) then
		{
			_value = (group player) getVariable "tf_lr_frequency";
		};
		if (isNil "_value") then {
			_value = call TFAR_fnc_generateLrSettings;
		};
	} else {
		_value = TF_saved_active_lr_settings;
	};
	if (TF_use_saved_lr_setting) then {
		TF_use_saved_lr_setting = false;
	};
	[_radio_object, _radio_qualifier, + _value] call TFAR_fnc_setLrSettings;
};
_rc = _value select TF_CODE_OFFSET;
if (isNil "_rc") then {
	private ["_code", "_hasDefaultEncryption"];
	_code = getText (ConfigFile >>  "CfgVehicles" >> (typeof _radio_object) >> "tf_encryptionCode");
	_hasDefaultEncryption = (_code == "tf_west_radio_code") or {_code == "tf_east_radio_code"} or {_code == "tf_guer_radio_code"};
	if (_hasDefaultEncryption) then {
		if ((call TFAR_fnc_getDefaultRadioClasses select 0) == (typeof _radio_object)) then {
			_rc = missionNamespace getVariable format ["tf_%1_radio_code",(side player)];
		}else{
			_rc = missionNamespace getVariable [[_radio_object, "tf_encryptionCode"] call TFAR_fnc_getLrRadioProperty, ""];
		};
	} else {
		_rc = "";
		if (_code != "") then {
			_rc = missionNamespace getVariable [[_radio_object, "tf_encryptionCode"] call TFAR_fnc_getLrRadioProperty, ""];
		};
	};
	
	_value set [TF_CODE_OFFSET, _rc];
	[_radio_object, _radio_qualifier, + _value] call TFAR_fnc_setLrSettings;
};
_value