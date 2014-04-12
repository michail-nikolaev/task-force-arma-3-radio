/*
 	Name: TFAR_fnc_ShowRadioInfo
 	
 	Author(s):
		L-H
 	
 	Description:
 	
 	Parameters: 
	0: OBJECT/STRING - Radio
	1: BOOLEAN - is LR radio
 	
 	Returns:
	Nothing
 	
 	Example:
	// LR radio
	[(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_ShowRadioInfo;
	// SW radio
	[(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_ShowRadioInfo;
*/
private ["_hintText", "_radio", "_isLrRadio", "_name", "_picture", "_channel", "_additional", "_add_channel", "_imagesize"];
_radio = _this select 0;
_isLrRadio = _this select 1;

_name = if(_isLrRadio) then {getText (ConfigFile >> "CfgVehicles" >> typeof (_radio select 0) >> "displayName")} else {getText(configFile >> "CfgWeapons" >> _radio >> "displayName")};
_picture = if(_isLrRadio) then {getText (ConfigFile >> "CfgVehicles" >> typeof (_radio select 0) >> "picture")} else {getText(configFile >> "CfgWeapons" >> _radio >> "picture")};

_channel = if(_isLrRadio) then {format[localize "STR_active_lr_channel", (_radio call TFAR_fnc_getLrChannel) + 1]} else {format[localize "STR_active_sw_channel", (_radio call TFAR_fnc_getSwChannel) + 1]};
_additional = nil;
if (_isLrRadio) then {
	_additional = _radio call TFAR_fnc_getAdditionalLrChannel;
} else {
	_additional = _radio call TFAR_fnc_getAdditionalSwChannel;
};
_add_channel = "";
if (_additional > -1) then {
	_add_channel = if(_isLrRadio) then {format[localize "STR_active_additional_lr_channel", (_radio call TFAR_fnc_getAdditionalLrChannel) + 1]} else {format[localize "STR_active_additional_sw_channel", (_radio call TFAR_fnc_getAdditionalSwChannel) + 1]};
};

_imagesize = "1.6";
if ((_isLrRadio) and {!((_radio select 0) isKindOf "Bag_Base")}) then {
	_imagesize = "1.0";
};
_hintText = format [("<t size='1' align='center'>%1 <img size='" + _imagesize + "' image='%2'/></t><br /><t align='center'>%3</t><br /><t align='center'>%4</t><br /><t align='center'>%5</t>"), _name,_picture,_channel,
	format[localize "STR_active_frequency", if(_isLrRadio) then {_radio call TFAR_fnc_getLrFrequency} else {_radio call TFAR_fnc_getSwFrequency}], _add_channel];
	
[parseText (_hintText), 5] call TFAR_fnc_showHint;