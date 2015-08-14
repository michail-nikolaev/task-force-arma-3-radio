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
private ["_radio_object", "_radio_qualifier", "_value", "_rc", "_radioType"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _radio_object getVariable _radio_qualifier;

if (_radio_object isKindOf "Bag_Base") then {
	_radioType = typeof _radio_object;
} else {
	_radioType = _radio_object getVariable "TF_RadioType";
	if (isNil "_radioType") then {
		_radioType = [typeof _radio_object, "tf_RadioType"] call TFAR_fnc_getConfigProperty;
		if ((isNil "_radioType") or {_radioType == ""}) then {
			_air = (typeof(_radio_object) isKindOf "Air");
			if ((_radio_object call TFAR_fnc_getVehicleSide) == west) then {			
				if (_air) then {
					_radioType = TF_defaultWestAirborneRadio;
				} else {
					_radioType = TF_defaultWestBackpack;
				};
			} else {
				if ((_radio_object call TFAR_fnc_getVehicleSide) == east) then {
					if (_air) then {
						_radioType = TF_defaultEastAirborneRadio;
					} else {
						_radioType = TF_defaultEastBackpack;
					};				
				} else {
					if (_air) then {
						_radioType = TF_defaultGuerAirborneRadio;
					} else {
						_radioType = TF_defaultGuerBackpack;
					};				
				};
			};
		};				
	};
};		

if (isNil "_value") then {
	if (!(TF_use_saved_lr_setting) or (isNil "TF_saved_active_lr_settings")) then {		
		if (((call TFAR_fnc_getDefaultRadioClasses select 0) == _radioType) or {(call TFAR_fnc_getDefaultRadioClasses select 3) == _radioType} or {getText(configFile >> "CfgVehicles" >> _radioType >> "tf_encryptionCode") == toLower (format ["tf_%1_radio_code",(TFAR_currentUnit call BIS_fnc_objectSide)])}) then {
			_value = (group TFAR_currentUnit) getVariable "tf_lr_frequency";
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
	_rc = _value select TF_CODE_OFFSET;
	if (isNil "_rc") then {
		private ["_code", "_hasDefaultEncryption"];
		_code = [_radio_object, "tf_encryptionCode"] call TFAR_fnc_getLrRadioProperty;
		_hasDefaultEncryption = (_code == "tf_west_radio_code") or {_code == "tf_east_radio_code"} or {_code == "tf_guer_radio_code"};
		if (_hasDefaultEncryption and {((TFAR_currentUnit call BIS_fnc_objectSide) != civilian)}) then {
			if (((call TFAR_fnc_getDefaultRadioClasses select 0) == _radioType) or {(call TFAR_fnc_getDefaultRadioClasses select 3) == _radioType} or {_radio_object call TFAR_fnc_getVehicleSide == TFAR_currentUnit call BIS_fnc_objectSide}) then {
				_rc = missionNamespace getVariable format ["tf_%1_radio_code",(TFAR_currentUnit call BIS_fnc_objectSide)];
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
	};
	[_radio_object, _radio_qualifier, + _value] call TFAR_fnc_setLrSettings;
};
_value