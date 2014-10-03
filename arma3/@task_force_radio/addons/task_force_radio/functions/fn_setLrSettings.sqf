/*
 	Name: TFAR_fnc_setLrSettings
 	
 	Author(s):
		NKey

 	Description:
		Saves the settings for the passed radio and broadcasts it to all clients and the server.
	
	Parameters:
		0: OBJECT - Radio object
		1: STRING - Radio ID
		2: ARRAY - Settings, usually acquired via TFAR_fnc_getLrSettings and then changed.
 	
 	Returns:
		Nothing
 	
 	Example:
		_settings = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getSwSettings;
		_settings set [0, 2]; // sets the active channel to 2
		[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _settings] call TFAR_fnc_setLrSettings;
*/
private ["_radio_object", "_radio_qualifier", "_value"];
_radio_object = _this select 0;
_radio_qualifier = _this select 1;
_value = _this select 2;
_radio_object setVariable [_radio_qualifier, + _value, true];