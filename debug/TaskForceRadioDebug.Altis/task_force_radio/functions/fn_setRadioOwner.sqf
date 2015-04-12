/*
 	Name: TFAR_fnc_setRadioOwner
 	
 	Author(s):
		L-H
 	
 	Description:
		Sets the owner of a SW radio.
 	
 	Parameters:
		0: STRING - radio classname
		1: STRING - UID of owner
		2: BOOLEAN - Local only
 	
 	Returns:
		Nothing
 	
 	Example:
		[(call TFAR_fnc_activeSwRadio),player] call TFAR_fnc_setRadioOwner;
*/
#include "script.h"
private ["_radio", "_settings", "_local"];
_radio = _this select 0;

_local = false;
if (count _this == 3) then {
	_local = _this select 2;
};

_settings = _radio call TFAR_fnc_getSwSettings;
_settings set [RADIO_OWNER, _this select 1];
[_radio, _settings, _local] call TFAR_fnc_setSwSettings;

//							owner, radio ID
["OnRadioOwnerSet", TFAR_currentUnit, [TFAR_currentUnit, _radio]] call TFAR_fnc_fireEventHandlers;