/*
 	Name: TFAR_fnc_ShowRadioVolume
 	
 	Author(s):
		L-H
 	
 	Description:
 	
 	Parameters: 
	0: OBJECT/STRING - Radio
	1: BOOLEAN - DD radio (Optional)
 	
 	Returns:
	Nothing
 	
 	Example:
	// LR radio
	[(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_ShowRadioVolume;
	// SW radio
	[(call TFAR_fnc_activeSwRadio)] call TFAR_fnc_ShowRadioVolume;
	// DD radio
	["", true] call TFAR_fnc_ShowRadioVolume;
*/
private ["_hintText", "_radio", "_isLrRadio", "_name", "_picture", "_volume"];
_radio = _this select 0;
_isDDRadio = [_this,1,false,[true]] call BIS_fnc_param;
_isLrRadio = if (typename _radio == "STRING")then{false}else{true};

if !(_isDDRadio) then
{
	_name = if(_isLrRadio) then {getText (ConfigFile >> "CfgVehicles" >> typeof (_radio select 0) >> "displayName")} else {getText(configFile >> "CfgWeapons" >> _radio >> "displayName")};
	_picture = if(_isLrRadio) then {getText (ConfigFile >> "CfgVehicles" >> typeof (_radio select 0) >> "picture")} else {getText(configFile >> "CfgWeapons" >> _radio >> "picture")};
	_volume = formatText [localize "STR_radio_volume",if(_isLrRadio) then {((_radio call TFAR_fnc_getLrVolume) + 1) * 10} else {((_radio call TFAR_fnc_getSwVolume) + 1) * 10}];
	_hintText = format ["%1<img size='1.5' image='%2'/><br />%3<br />%4", _name,_picture,_volume,
	localize format ["STR_stereo_settings_%1", if(_isLrRadio) then {_radio call TFAR_fnc_getLrStereo} else {_radio call TFAR_fnc_getSwStereo}]];
}
else
{
	_hintText = format ["%1<br />%2", "DD Radio",formatText [localize "STR_radio_volume",((TF_dd_volume_level + 1) * 10)]];
};
	
[parseText (_hintText), 5] call TFAR_fnc_showHint;