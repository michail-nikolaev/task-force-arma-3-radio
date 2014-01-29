private ["_radio_object", "_radio_qualifier", "_value"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _this select 2;
_radio_object setVariable [_radio_qualifier, _value, true];