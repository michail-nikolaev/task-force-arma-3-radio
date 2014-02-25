private ["_sw_channel_number", "_hintText", "_result"];
_sw_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then
{
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	[_radio, _sw_channel_number] call TFAR_fnc_setSwChannel;
	[_radio, false] call TFAR_fnc_ShowRadioInfo;
	if (dialog) then {
		call compile getText(configFile >> "CfgWeapons" >> _radio >> "tf_dialogUpdate");
	};
	_result = true;
};
_result