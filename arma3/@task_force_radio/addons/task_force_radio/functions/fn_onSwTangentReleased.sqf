private["_result", "_request"];
if ((tangent_sw_pressed) and {alive player}) then {
	hintSilent "";
	_request = format["TANGENT	RELEASED	%1%2",call TFAR_fnc_currentSWFrequency, (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode];
	if (isMultiplayer) then {
		_result = "task_force_radio_pipe" callExtension _request;
	};
	tangent_sw_pressed = false;
};
true