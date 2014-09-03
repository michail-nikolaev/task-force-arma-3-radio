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
#include "script.h"
private ["_variableName", "_value", "_rc"];
_variableName = format["%1_settings", _this];
_value = missionNamespace getVariable _variableName;
if (isNil "_value") then {
	if (!(TF_use_saved_sw_setting) or (isNil "TF_saved_active_sw_settings")) then {
		private ["_parent", "_defaultRadios"];
		_defaultRadios = call TFAR_fnc_getDefaultRadioClasses;
		_parent = getText (ConfigFile >> "CfgWeapons" >> _this >> "tf_parent");
		if ((_defaultRadios select 1) == _parent or {(_defaultRadios select 2) == _parent}) then {
			_value = (group player) getVariable "tf_sw_frequency";
		};
		if (isNil "_value") then {
			_value = call TFAR_fnc_generateSwSettings;
		};			
	} else {
		_value = TF_saved_active_sw_settings;
	};
	if (TF_use_saved_sw_setting) then {
		TF_use_saved_sw_setting = false;
	};
	[_this, + _value] call TFAR_fnc_setSwSettings;
};
_rc = _value select TF_CODE_OFFSET;
if (isNil "_rc") then {
	private ["_parent", "_code", "_hasDefaultEncryption"];
	_code = getText (ConfigFile >>  "CfgWeapons" >> _this >> "tf_encryptionCode");
	_hasDefaultEncryption = (_code == "tf_west_radio_code") or {_code == "tf_east_radio_code"} or {_code == "tf_guer_radio_code"};
	if (_hasDefaultEncryption and {(player call BIS_fnc_objectSide) != civilian}) then {
		_parent = getText (ConfigFile >> "CfgWeapons" >> _this >> "tf_parent");
		private "_default";
		_default = call TFAR_fnc_getDefaultRadioClasses;
		if ((_default select 1) == _parent or {(_default select 2) == _parent}) then {
			_rc = missionNamespace getVariable format ["tf_%1_radio_code", (player call BIS_fnc_objectSide)];
		}else{
			_rc = missionNamespace getVariable [_code, ""];
		};
	} else {
		_rc = "";
		if (_code != "") then {
			_rc = missionNamespace getVariable [_code, ""];
		};
	};
	_value set [TF_CODE_OFFSET, _rc];
	[_this, + _value] call TFAR_fnc_setSwSettings;
};
_value