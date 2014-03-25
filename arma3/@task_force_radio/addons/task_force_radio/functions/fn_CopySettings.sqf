/*
 	Name: TFAR_fnc_copySettings
 	
 	Author(s):
		L-H
 	
 	Description:
		Copies the settings from a radio to another.
 	
 	Parameters:
		0:ARRAY/STRING - Source Radio (SW/LR)
		1:ARRAY/STRING - Destination Radio (SW/LR)
 	
 	Returns:
		Nothing
 	
 	Example:
	// LR - LR
	[(call TFAR_fnc_activeLrRadio),[(vehicle player), "driver"]] call TFAR_fnc_CopySettings;
	// SW - SW
	[(call TFAR_fnc_activeSwRadio),"tf_anprc148jem_20"] call TFAR_fnc_CopySettings;
	// LR - SW
	[(call TFAR_fnc_activeLrRadio),"tf_anprc148jem_20"] call TFAR_fnc_CopySettings;
	// SW - LR
	[(call TFAR_fnc_activeSwRadio),(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_CopySettings;
*/
#include "script.h"
private ["_source", "_destination", "_settings", "_isDLR", "_isSLR"];
_source = _this select 0;
_destination = _this select 1;

_isDLR = if (typename _destination == typename []) then {true}else{false};
_isSLR = if (typename _source == typename []) then {true}else{false};

if (_isSLR) then {
	_settings = _source call TFAR_fnc_GetLRSettings;
} else {
	_settings = _source call TFAR_fnc_GetSwSettings;
};

if (_isDLR) then {
	[_destination select 0, _destination select 1,[]+_settings] call TFAR_fnc_SetLRSettings;
} else {
	[_destination, []+_settings] call TFAR_fnc_SetSwSettings;
};