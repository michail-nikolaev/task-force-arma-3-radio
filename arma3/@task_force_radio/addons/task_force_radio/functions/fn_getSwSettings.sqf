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
		private "_parent";
		_parent = getText (ConfigFile >> "CfgWeapons" >> _this >> "tf_parent");
		if (([side player, 1] call TFAR_fnc_getSideRadio) == _parent or {([side player, 2] call TFAR_fnc_getSideRadio) == _parent}) then
		{
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
if (isNil "_rc") then
{
	private "_parent";
	if (getText (ConfigFile >>  "CfgWeapons" >> _this >> "tf_encryptionCode") != "") then {
		_parent = getText (ConfigFile >> "CfgWeapons" >> _this >> "tf_parent");
		if (([side player, 1] call TFAR_fnc_getSideRadio) == _parent or {([side player, 2] call TFAR_fnc_getSideRadio) == _parent}) then {
			_rc = missionNamespace getVariable format ["tf_%1_radio_code",(side player)];
		}else{
			_rc = missionNamespace getVariable [getText(configFile >> "CfgWeapons" >> _this >> "tf_encryptionCode"), ""];
		};
	} else {
		_rc = "";
	};
	_value set [TF_CODE_OFFSET, _rc];
	[_this, + _value] call TFAR_fnc_setSwSettings;
};
_value