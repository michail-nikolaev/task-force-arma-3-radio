#include "script.h"
private ["_radio"];
_radio = _this select 0;

[_radio, ((_radio call TFAR_fnc_getSwSettings) select ACTIVE_CHANNEL_OFFSET)+1, _this select 1] call TFAR_fnc_setChannelFrequency;