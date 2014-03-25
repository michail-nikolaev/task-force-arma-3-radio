/*
 	Name: TFAR_fnc_getSwVolume
 	
 	Author(s):
		NKey

 	Description:
		Gets the volume of the passed radio
	
	Parameters:
		STRING: Radio classname
 	
 	Returns:
		NUMBER: Volume : range (0,10)
 	
 	Example:
		_volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;
*/
#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getSwSettings;
_settings select VOLUME_OFFSET