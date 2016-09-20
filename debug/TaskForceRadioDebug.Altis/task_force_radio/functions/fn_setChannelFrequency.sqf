/*
 	Name: TFAR_fnc_SetChannelFrequency
 	
 	Author(s):
		L-H
 	
 	Description:
		Sets the frequency for the channel on the passed radio.
 	
 	Parameters: 
 	0: OBJECT/String - Radio
	1: NUMBER - Channel
	2: STRING - Frequency
 	
 	Returns:
	Nothing
 	
 	Example:
	// LR radio - channel 1
	[(call TFAR_fnc_activeLrRadio), 1, "56.2"] call TFAR_fnc_SetChannelFrequency;
	// SW radio - channel 1
	[(call TFAR_fnc_activeSwRadio), 1, "84.3"] call TFAR_fnc_SetChannelFrequency;
*/
#include "script.h"
private ["_radio", "_channel", "_settings", "_frequency", "_lr"];
_radio = _this select 0;
_channel = (_this select 1) - 1;
_frequency = _this select 2;

_lr = if (typename _radio == "STRING") then { false }else{true};

if (_lr) then {
	_settings = _radio call TFAR_fnc_getLrSettings;
} else {
	_settings = _radio call TFAR_fnc_getSwSettings;
};

if (isNil "_settings") exitWith {};

(_settings select TF_FREQ_OFFSET) set [_channel, _frequency];

if (_lr) then {
	[_radio select 0, _radio select 1, _settings] call TFAR_fnc_setLrSettings;
} else {
	[_radio, _settings] call TFAR_fnc_setSwSettings;
};