/*
 	Name: TFAR_fnc_setLrFrequency
 	
 	Author(s):
		NKey

 	Description:
		Sets the frequency for the active channel
	
	Parameters:
		0: OBJECT - Radio object
		1: STRING - Radio ID
		2: STRING - Frequency
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, "45.48"] call TFAR_fnc_setLrFrequency;
*/
#include "script.h"
private ["_radio"];
_radio = [_this select 0, _this select 1];

[_radio, ((_radio call TFAR_fnc_getLrSettings) select ACTIVE_CHANNEL_OFFSET)+1, _this select 2] call TFAR_fnc_setChannelFrequency;