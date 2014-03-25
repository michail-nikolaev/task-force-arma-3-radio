/*
 	Name: TFAR_fnc_setSwFrequency
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
		Sets the frequency for the currently active channel
 	
 	Parameters: 
		0: STRING - Radio classname
		1: STRING - Frequency
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeSwRadio), "76.2"] call TFAR_fnc_setSwFrequency;
*/
#include "script.h"
private ["_radio"];
_radio = _this select 0;

[_radio, ((_radio call TFAR_fnc_getSwSettings) select ACTIVE_CHANNEL_OFFSET)+1, _this select 1] call TFAR_fnc_setChannelFrequency;