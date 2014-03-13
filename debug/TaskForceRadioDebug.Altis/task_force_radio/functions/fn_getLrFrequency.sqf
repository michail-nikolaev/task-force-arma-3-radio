#include "script.h"
private ["_settings"];
_settings = _this call TFAR_fnc_getLrSettings;
(_settings select TF_FREQ_OFFSET) select (_settings select ACTIVE_CHANNEL_OFFSET)