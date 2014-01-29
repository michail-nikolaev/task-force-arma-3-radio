#include "script.h"
private ["_radio_id", "_freq", "_settings"];
_radio_id = _this select 0;
_freq = _this select 1;
_settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [(_settings select ACTIVE_CHANNEL_OFFSET) + FREQ_OFFSET, _freq];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;