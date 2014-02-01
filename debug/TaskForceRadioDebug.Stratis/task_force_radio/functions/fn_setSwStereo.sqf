#include "script.h"
private ["_settings", "_radio_id", "_value_to_set"];
_radio_id = _this select 0;
_value_to_set = _this select 1;
_settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [SW_STEREO_OFFSET, _value_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSetting;