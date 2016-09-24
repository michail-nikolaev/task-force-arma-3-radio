#include "script_component.hpp"

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

private ["_settings"];
_settings = _this call TFAR_fnc_getSwSettings;
_settings select ACTIVE_CHANNEL_OFFSET