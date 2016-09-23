/*
 	Name: TFAR_fnc_getLrChannel
 	
 	Author(s):
		NKey

 	Description:
		Gets the channel for the passed radio
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		NUMBER: Channel
 	
 	Example:
		_channel = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrChannel;
*/
#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getLrSettings;
_settings select ACTIVE_CHANNEL_OFFSET