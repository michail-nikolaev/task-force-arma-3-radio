private ["_sw_channel_number", "_hintText", "_result"];
_sw_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then {		
	[call TFAR_fnc_activeSwRadio, _sw_channel_number] call TFAR_fnc_setSwChannel;
	_hintText = format[localize "STR_active_sw_channel", _sw_channel_number + 1];
	hint parseText (_hintText);
	if (dialog) then {
		call compile getText(configFile >> "CfgWeapons" >> (call TFAR_fnc_activeSwRadio) >> "tf_dialogUpdate");
	};
	_result = true;

};
_result