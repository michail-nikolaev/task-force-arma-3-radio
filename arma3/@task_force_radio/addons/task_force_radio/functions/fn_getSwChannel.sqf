/*
 	Name: TFAR_fnc_getSwChannel
 	
 	Author(s):
		NKey

 	Description:
		Gets the channel for the passed radio
	
	Parameters:
		STRING: Radio classname
 	
 	Returns:
		NUMBER: Channel
 	
 	Example:
		_channel = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwChannel;
*/
#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getSwSettings;
_settings select ACTIVE_CHANNEL_OFFSET