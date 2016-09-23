/*
 	Name: TFAR_fnc_getLrSpeakers
 	
 	Author(s):
		NKey

 	Description:
		Gets the speakers setting of the passed radio
	
	Parameters:
		Array: Radio
			0: OBJECT - Radio object
			1: STRING - Radio ID
 	
 	Returns:
		BOOLEAN : speakers or headphones
 	
 	Example:
		_speakers = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrSpeakers;
*/
#include "script.h"
private ["_settings", "_result"];
_settings = _this call TFAR_fnc_getLrSettings;
_result = false;
if (count _settings > TF_LR_SPEAKER_OFFSET) then {
	_result = _settings select TF_LR_SPEAKER_OFFSET;
};
_result