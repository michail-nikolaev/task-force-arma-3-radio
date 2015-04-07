/*
 	Name: TFAR_fnc_setLrSpeakers
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the speakers setting for the passed radio
 	
 	Parameters:
		0: OBJECT - Radio object
		1: STRING - Radio ID		
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1] call TFAR_fnc_setLrSpeakers;
*/
#include "script.h"
private ["_radio_object", "_radio_qualifier", "_flag", "_settings"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;

_settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
if (_settings select TF_LR_SPEAKER_OFFSET) then {
	_settings set [TF_LR_SPEAKER_OFFSET, false];
} else {
	_settings set [TF_LR_SPEAKER_OFFSET, true];
	_flag = TFAR_currentUnit getVariable "tf_lr_speakers";
	if (isNil "_flag") then {
		TFAR_currentUnit setVariable ["tf_lr_speakers", true, true];
	};
	_flag = _radio_object getVariable "tf_lr_speakers";
	if (isNil "_flag") then {
		_radio_object setVariable ["tf_lr_speakers", true, true];
	};
};
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			speakers
["OnLRspeakersSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_object, _radio_qualifier, _settings select TF_LR_SPEAKER_OFFSET]] call TFAR_fnc_fireEventHandlers;