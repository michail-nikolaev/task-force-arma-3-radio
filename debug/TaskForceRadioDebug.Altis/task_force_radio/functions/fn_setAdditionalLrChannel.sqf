/*
 	Name: TFAR_fnc_setAdditionalLrChannel
 	
 	Author(s):
		NKey

 	Description:
		Sets the radio to the passed channel or disables it (if current additional passed).
	
	Parameters:
		0: OBJECT - Radio object
		1: STRING - Radio ID
		2: NUMBER - Channel : Range (0,8)
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, 4] call TFAR_fnc_setAdditionalLrChannel;
*/
#include "script.h"
private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _this select 2;
_settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
if ((_settings select TF_ADDITIONAL_CHANNEL_OFFSET) != _value) then {
	_settings set [TF_ADDITIONAL_CHANNEL_OFFSET, _value];
} else {
	_settings set [TF_ADDITIONAL_CHANNEL_OFFSET, -1];
};
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			channel, additional
["OnLRchannelSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, true]] call TFAR_fnc_fireEventHandlers;