#include "script.h"
private ["_radio_object", "_radio_qualifier", "_value"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _radio_object getVariable _radio_qualifier;
if (isNil "_value") then {
	if (!(use_saved_lr_setting) or (isNil "saved_active_lr_settings")) then {
		_value = (group player) getVariable "tf_lr_frequency";
		if (isNil "_value") then {
			_value = call TFAR_fnc_generateLrSettings;			
		};
	} else {
		_value = saved_active_lr_settings;
	};
	if (use_saved_lr_setting) then {
		use_saved_lr_setting = false;
	};
	[_radio_object, _radio_qualifier, + _value] call TFAR_fnc_setLrSettings;
};
_value