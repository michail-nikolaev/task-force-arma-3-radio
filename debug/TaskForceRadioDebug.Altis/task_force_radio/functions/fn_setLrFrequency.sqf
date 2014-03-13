#include "script.h"
private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _this select 2;

_settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
(_settings select TF_FREQ_OFFSET) set [(_settings select ACTIVE_CHANNEL_OFFSET), _value];
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;