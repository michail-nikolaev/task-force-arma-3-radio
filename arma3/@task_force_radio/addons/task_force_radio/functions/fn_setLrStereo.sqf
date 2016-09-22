/*
 	Name: TFAR_fnc_setLrStereo
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the stereo setting for the passed radio
 	
 	Parameters:
		0: OBJECT - Radio object
		1: STRING - Radio ID
		2: NUMBER - Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)			
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, 1] call TFAR_fnc_setLrStereo;
*/
#include "script.h"
private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _this select 2;
if (([_radio_object, _radio_qualifier] call TFAR_fnc_getAdditionalLrChannel) == ([_radio_object, _radio_qualifier] call TFAR_fnc_getLrChannel)) then {
	_this call TFAR_fnc_setAdditionalLrStereo;
} else {
	_settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
	_settings set [TF_LR_STEREO_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;
	
	//							unit, radio object,		radio ID			channel, additional
	["OnLRstereoSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, false]] call TFAR_fnc_fireEventHandlers;
};