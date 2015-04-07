/*
 	Name: TFAR_fnc_setLrVolume
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the volume for the passed radio
 	
 	Parameters:
		0: OBJECT - Radio object
		1: STRING - Radio ID
		2: NUMBER - Volume : Range (0,10)
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, 5] call TFAR_fnc_setLrVolume;
*/
#include "script.h"
private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _this select 2;
_settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
_settings set [VOLUME_OFFSET, _value];
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;

//							Unit, radio object, radio ID, volume
["OnLRvolumeSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_object, _radio_qualifier, _value]] call TFAR_fnc_fireEventHandlers;