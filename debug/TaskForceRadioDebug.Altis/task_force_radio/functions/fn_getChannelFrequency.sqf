/*
 	Name: TFAR_fnc_GetChannelFrequency
 	
 	Author(s):
		L-H
 	
 	Description:
		Returns the frequency for the passed channel and radio.
 	
 	Parameters: 
 	0: OBJECT/String - Radio
	1: NUMBER - Channel
 	
 	Returns:
	STRING - Frequency
 	
 	Example:
	// LR radio - channel 1
	[(call TFAR_fnc_activeLrRadio), 1] call TFAR_fnc_GetChannelFrequency;
	// SW radio - channel 1
	[(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_GetChannelFrequency;
*/
#include "script.h"
private ["_radio", "_channel", "_settings"];
_radio = _this select 0;
_channel = (_this select 1) - 1;

if (typename _radio == "STRING") then {
	_settings = _radio call TFAR_fnc_getSwSettings;
} else {
	_settings = _radio call TFAR_fnc_getLrSettings;
};

if (!isNil "_settings") then {
	((_settings select TF_FREQ_OFFSET) select _channel)
} else {
	"";
};