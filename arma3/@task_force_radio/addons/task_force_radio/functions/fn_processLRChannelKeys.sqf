private ["_lr_channel_number","_hintText","_result","_active_lr"];
_lr_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveLRRadio) and {alive player}) then {
	_active_lr = call TFAR_fnc_activeLrRadio;
	[_active_lr select 0, _active_lr select 1, _lr_channel_number] call TFAR_fnc_setLrChannel;
	
	_hintText = format ["%1<img size='1.5' image='%5'/><br />%2<br />%3<br />%4", getText (ConfigFile >> "CfgVehicles" >> typeof (_active_lr select 0) >> "displayName"),
		format[localize "STR_active_lr_channel", _lr_channel_number + 1],
		format[localize "STR_active_frequency", _active_lr call TFAR_fnc_getLrFrequency],
		localize format ["STR_stereo_settings_%1", _active_lr call TFAR_fnc_getLrStereo],
		getText(configFile >> "CfgVehicles"  >>  typeof (_active_lr select 0) >> "picture")];
	
	[parseText (_hintText), 5] call TFAR_fnc_showHint;
	if (dialog) then {
		call compile ([_active_lr select 0, "tf_dialogUpdate"] call TFAR_fnc_getLrRadioProperty);
	};
	_result = true;
};
_result