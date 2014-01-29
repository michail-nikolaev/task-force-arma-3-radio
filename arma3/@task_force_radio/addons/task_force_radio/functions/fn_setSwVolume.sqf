#include "script.h"
private ["_settings", "_radio_id", "_value"];
_radio_id = _this select 0;
_value = _this select 1;
_settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [VOLUME_OFFSET, _value];
[_radio_id, _settings] call TFAR_fnc_setSwSetting;