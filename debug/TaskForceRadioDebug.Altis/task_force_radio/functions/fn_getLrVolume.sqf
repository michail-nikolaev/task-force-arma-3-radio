/*
 	Name: TFAR_fnc_getLrVolume
 	
 	Author(s):
		NKey

 	Description:
		Gets the volume of the passed radio
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		NUMBER: Volume : range (0,10)
 	
 	Example:
		_volume = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrVolume;
*/
#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getLrSettings;
_settings select VOLUME_OFFSET