/*
 	Name: TFAR_fnc_getLrFrequency
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Gets the frequency for the active channel.
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		NUMBER: Frequency
 	
 	Example:
		_frequency = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrFrequency;
*/
#include "script.h"
[_this, ((_this call TFAR_fnc_getLrSettings) select ACTIVE_CHANNEL_OFFSET)+1] call TFAR_fnc_GetChannelFrequency;