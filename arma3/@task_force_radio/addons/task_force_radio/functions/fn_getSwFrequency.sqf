#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getSwSettings;
_settings select (TF_FREQ_OFFSET + (_settings select ACTIVE_CHANNEL_OFFSET))