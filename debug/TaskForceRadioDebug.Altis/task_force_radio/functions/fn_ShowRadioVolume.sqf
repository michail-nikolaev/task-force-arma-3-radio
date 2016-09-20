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
private ["_hintText", "_radio", "_isLrRadio", "_name", "_picture", "_volume", "_stereo", "_add_stereo", "_additional", "_imagesize"];
_radio = _this select 0;
_isDDRadio = [_this,1,false,[true]] call BIS_fnc_param;
_isLrRadio = if (typename _radio == "STRING")then{false}else{true};

if !(_isDDRadio) then {
	_name = if(_isLrRadio) then {getText (ConfigFile >> "CfgVehicles" >> typeof (_radio select 0) >> "displayName")} else {getText(configFile >> "CfgWeapons" >> _radio >> "displayName")};
	_picture = if(_isLrRadio) then {getText (ConfigFile >> "CfgVehicles" >> typeof (_radio select 0) >> "picture")} else {getText(configFile >> "CfgWeapons" >> _radio >> "picture")};
	_volume = formatText [localize "STR_radio_volume",if(_isLrRadio) then {((_radio call TFAR_fnc_getLrVolume) + 1) * 10} else {((_radio call TFAR_fnc_getSwVolume) + 1) * 10}];
	_stereo = localize format ["STR_stereo_settings_%1", if(_isLrRadio) then {_radio call TFAR_fnc_getLrStereo} else {_radio call TFAR_fnc_getSwStereo}];
	
	if (_isLrRadio) then {
		_additional = _radio call TFAR_fnc_getAdditionalLrChannel;
	} else {
		_additional = _radio call TFAR_fnc_getAdditionalSwChannel;
	};
	_add_stereo = "";
	if (_additional > -1) then {
		_add_stereo =  localize format ["STR_additional_stereo_settings_%1", if(_isLrRadio) then {_radio call TFAR_fnc_getAdditionalLrStereo} else {_radio call TFAR_fnc_getAdditionalSwStereo}];
	};
	_imagesize = "1.6";
	if ((_isLrRadio) and {!((_radio select 0) isKindOf "Bag_Base")}) then {
		_imagesize = "1.0";
	};
	_hintText = format [("<t size='1' align='center'>%1 <img size='" + _imagesize + "' image='%2'/></t><br /><t align='center'>%3</t><br /><t align='center'>%4</t><br /><t size='0.8' align='center'>%5</t>"), _name,_picture,_volume, _stereo, _add_stereo];
}else{
	_hintText = format ["%1<br />%2", "DD Radio",formatText [localize "STR_radio_volume",((TF_dd_volume_level + 1) * 10)]];
};
	
[parseText (_hintText), 5] call TFAR_fnc_showHint;