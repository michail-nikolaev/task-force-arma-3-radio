/*
 	Name: TFAR_fnc_getCurrentLrStereo
 	
 	Author(s):
		NKey

 	Description:
		Gets the stereo of current channel (special logic for additional) setting of the passed radio
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		NUMBER: Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)
 	
 	Example:
		_stereo = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getCurrentLrStereo;
*/
#include "script.h"
private ["_result"];
_result = 0;
if ((_this call TFAR_fnc_getAdditionalLrChannel) == (_this call TFAR_fnc_getLrChannel)) then {
	_result = _this call TFAR_fnc_getAdditionalLrStereo;
} else {
	_result = _this call TFAR_fnc_getLrStereo;
};
_result