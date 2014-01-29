#include "script.h"
private ["_settings", "_result"];
_settings = _this call TFAR_fnc_getLrSettings;
_result = 0;
if (count _settings > LR_STEREO_OFFSET) then {
	_result = _settings select LR_STEREO_OFFSET;
};
_result