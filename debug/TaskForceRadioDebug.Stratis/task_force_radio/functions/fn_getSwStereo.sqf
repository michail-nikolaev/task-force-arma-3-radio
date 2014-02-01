#include "script.h"
private ["_settings", "_result"];
_settings = _this call TFAR_fnc_getSwSettings;
_result = 0;
if (count _settings > SW_STEREO_OFFSET) then {
	_result = _settings select SW_STEREO_OFFSET;
};
_result