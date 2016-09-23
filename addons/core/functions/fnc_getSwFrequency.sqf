/*
 	Name: TFAR_fnc_getSwFrequency
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Gets the frequency for the active channel.
	
	Parameters:
		STRING: Radio classname
 	
 	Returns:
		NUMBER: Frequency
 	
 	Example:
		_frequency = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwFrequency;
*/
#include "script.h"
[_this, ((_this call TFAR_fnc_getSwSettings) select ACTIVE_CHANNEL_OFFSET)+1] call TFAR_fnc_GetChannelFrequency;