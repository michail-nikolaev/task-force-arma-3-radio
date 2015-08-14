/*
 	Name: TFAR_fnc_setSwChannel
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the channel for the passed radio
 	
 	Parameters: 
		0: STRING - Radio classname
		1: NUMBER - Channel
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeSwRadio), 2] call TFAR_fnc_setSwChannel;
*/
#include "script.h"
private ["_settings", "_radio_id", "_channel_to_set"];
_radio_id = _this select 0;
_channel_to_set = _this select 1;
_settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [ACTIVE_CHANNEL_OFFSET, _channel_to_set];
<<<<<<< HEAD
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,		channel, additional
["OnSWchannelSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_id, _channel_to_set, false]] call TFAR_fnc_fireEventHandlers;
=======
[_radio_id, _settings] call TFAR_fnc_setSwSettings;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
