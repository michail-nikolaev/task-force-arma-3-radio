#include "script.h"
private ["_radio"];
_radio = [_this select 0, _this select 1];

[_radio, (_radio call TFAR_fnc_getLrSettings) select ACTIVE_CHANNEL_OFFSET, _this select 2] call TFAR_fnc_setChannelFrequency;