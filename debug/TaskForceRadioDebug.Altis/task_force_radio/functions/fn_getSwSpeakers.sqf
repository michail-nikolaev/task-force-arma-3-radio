/*
 	Name: TFAR_fnc_getSwSpeakers
 	
 	Author(s):
		NKey

 	Description:
		Gets the speakers setting of the passed radio
	
	Parameters:
		STRING: Radio classname
 	
 	Returns:
		BOOLEAN: speakers or headphones
 	
 	Example:
		_stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwSpeakers;
*/
#include "script.h"
private ["_settings", "_result"];
_settings = _this call TFAR_fnc_getSwSettings;
_result = false;
if (count _settings > TF_SW_SPEAKER_OFFSET) then {
	_result = _settings select TF_SW_SPEAKER_OFFSET;
};
_result