private ["_sw_channel_number", "_hintText", "_result"];
_sw_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then
{
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	[_radio, _sw_channel_number] call TFAR_fnc_setSwChannel;
	_hintText = format ["%1<img size='1.5' image='%5'/><br />%2<br />%3<br />%4", getText(configFile >> "CfgWeapons" >> _radio >> "displayName"),
		format[localize "STR_active_sw_channel", _sw_channel_number + 1],
		format[localize "STR_active_frequency", _radio call TFAR_fnc_getSwFrequency],
		localize format ["STR_stereo_settings_%1", _radio call TFAR_fnc_getSwStereo],
		getText(configFile >> "CfgWeapons"  >> _radio >> "picture")];
	[parseText (_hintText), 5] call TFAR_fnc_showHint;
	if (dialog) then {
		call compile getText(configFile >> "CfgWeapons" >> _radio >> "tf_dialogUpdate");
	};
	_result = true;
};
_result