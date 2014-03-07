private ["_sw_stereo_number", "_result"];
_sw_stereo_number = _this select 0;
_result = false;

if ((alive player) and {call TFAR_fnc_haveSWRadio}) then
{
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	[_radio, _sw_stereo_number] call TFAR_fnc_setSwStereo;
	[_radio, false] call TFAR_fnc_ShowRadioInfo;
	_result = true;
};
_result
