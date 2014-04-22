/*
 	Name: TFAR_fnc_getAdditionalSwStereo
 	
 	Author(s):
		NKey

 	Description:
		Gets the stereo setting of additional channel of the passed radio
	
	Parameters:
		STRING: Radio classname
 	
 	Returns:
		NUMBER: Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)
 	
 	Example:
		_stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getAdditionalSwStereo;
*/
#include "script.h"
private ["_settings", "_result"];
_settings = _this call TFAR_fnc_getSwSettings;
_result = 0;
if (count _settings > TF_ADDITIONAL_STEREO_OFFSET) then {
	_result = _settings select TF_ADDITIONAL_STEREO_OFFSET;
};
_result