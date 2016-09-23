/*
 	Name: TFAR_fnc_getAdditionalSwChannel
 	
 	Author(s):
		NKey

 	Description:
		Gets the additional channel for the passed radio
	
	Parameters:
		STRING: Radio classname
 	
 	Returns:
		NUMBER: Channel
 	
 	Example:
		_channel = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getAdditionalSwChannel;
*/
#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getSwSettings;
_settings select TF_ADDITIONAL_CHANNEL_OFFSET