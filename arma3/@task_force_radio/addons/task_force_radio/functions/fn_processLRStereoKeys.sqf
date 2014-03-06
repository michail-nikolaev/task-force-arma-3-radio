private ["_lr_stereo_number", "_result"];
_lr_stereo_number = _this select 0;
_result = false;

if ({alive player} and (call TFAR_fnc_haveLRRadio)) then
{
	private "_radio";
	_radio = call TFAR_fnc_activeLrRadio;
	[_radio select 0, _radio select 1, _lr_stereo_number] call TFAR_fnc_setLrStereo;
	[_radio, true] call TFAR_fnc_ShowRadioInfo;
	_result = true;
};
_result
