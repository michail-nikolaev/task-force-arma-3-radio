#include "script.h"
private ["_variableName", "_value", "_preset"];
_variableName = format["%1_settings", _this];
_value = missionNamespace getVariable _variableName;
if (isNil "_value") then {
	if (!(TF_use_saved_sw_setting) or (isNil "TF_saved_active_sw_settings")) then {		
		_value = (group player) getVariable "tf_sw_frequency";
		if (isNil "_value") then {
			_value = call TFAR_fnc_generateSwSettings;
		};			
	} else {
		_value = TF_saved_active_sw_settings;
	};
	if (TF_use_saved_sw_setting) then {
		TF_use_saved_sw_setting = false;
	};
	[_this, + _value] call TFAR_fnc_setSwSettings;
};
_value