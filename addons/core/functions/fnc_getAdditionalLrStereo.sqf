/*
 	Name: TFAR_fnc_getAdditionalLrStereo
 	
 	Author(s):
		NKey

 	Description:
		Gets the stereo setting of additional channel of the passed radio
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		NUMBER: Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)
 	
 	Example:
		_stereo = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getAdditionalLrStereo;
*/
#include "script.h"
private ["_settings", "_result"];
_settings = _this call TFAR_fnc_getLrSettings;
_result = 0;
if (count _settings > TF_ADDITIONAL_STEREO_OFFSET) then {
	_result = _settings select TF_ADDITIONAL_STEREO_OFFSET;
};
_result