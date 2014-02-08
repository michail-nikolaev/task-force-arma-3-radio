private ["_radio_id", "_value", "_variableName"];
_radio_id = _this select 0;
_value = _this select 1;
_variableName = format["%1_settings", _radio_id];
missionNamespace setVariable [_variableName, _value];
publicVariable _variableName;