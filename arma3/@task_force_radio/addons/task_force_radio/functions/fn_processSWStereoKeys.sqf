private ["_sw_stereo_number", "_result"];
_sw_stereo_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then
{
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	[_radio, _sw_stereo_number] call TFAR_fnc_setSwStereo;
	[_radio, false] call TFAR_fnc_ShowRadioInfo;
	_result = true;
};
_result