private["_result", "_request"];
if ((TF_tangent_sw_pressed) and {alive player}) then {
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	_hintText = format[localize "STR_transmit_end",getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName"),
		(_radio call TFAR_fnc_getSwChannel) + 1, call TFAR_fnc_currentSWFrequency];
	[parseText (_hintText), 2.5] call TFAR_fnc_showHint;
	_request = format["TANGENT	RELEASED	%1%2",call TFAR_fnc_currentSWFrequency, (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode];
	if (isMultiplayer) then {
		_result = "task_force_radio_pipe" callExtension _request;
	};
	TF_tangent_sw_pressed = false;
};
true