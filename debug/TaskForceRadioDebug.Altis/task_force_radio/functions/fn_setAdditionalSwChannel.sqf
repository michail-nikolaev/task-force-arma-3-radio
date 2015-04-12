/*
 	Name: TFAR_fnc_setAdditionalSwChannel
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the additional channel for the passed radio or disables it (if additional channel in arguments).
 	
 	Parameters: 
		0: STRING - Radio classname
		1: NUMBER - Channel
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeSwRadio), 2] call TFAR_fnc_setAdditionalSwChannel;
*/
#include "script.h"
private ["_settings", "_radio_id", "_channel_to_set"];
_radio_id = _this select 0;
_channel_to_set = _this select 1;
_settings = _radio_id call TFAR_fnc_getSwSettings;
if ((_settings select TF_ADDITIONAL_CHANNEL_OFFSET) != _channel_to_set) then {
	_settings set [TF_ADDITIONAL_CHANNEL_OFFSET, _channel_to_set];
} else {
	_settings set [TF_ADDITIONAL_CHANNEL_OFFSET, -1];
};
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,		channel, additional
["OnSWchannelSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_id, _channel_to_set, true]] call TFAR_fnc_fireEventHandlers;