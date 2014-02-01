#include "script.h"
private ["_settings", "_radio_id", "_channel_to_set"];
_radio_id = _this select 0;
_channel_to_set = _this select 1;
_settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [ACTIVE_CHANNEL_OFFSET, _channel_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;