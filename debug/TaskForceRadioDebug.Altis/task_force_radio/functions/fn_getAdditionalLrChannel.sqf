/*
 	Name: TFAR_fnc_getAdditionalLrChannel
 	
 	Author(s):
		NKey

 	Description:
		Gets the additional channel for the passed radio
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		NUMBER: Channel
 	
 	Example:
		_channel = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getAdditionalLrChannel;
*/
#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getLrSettings;
_settings select TF_ADDITIONAL_CHANNEL_OFFSET