private["_result", "_request"];	
if ((TF_tangent_lr_pressed) and {alive player}) then {
	call TFAR_fnc_hideHint;
	_request = format["TANGENT_LR	RELEASED	%1%2", call TFAR_fnc_currentLRFrequency, (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrRadioCode];
	if (isMultiplayer) then {
		_result = "task_force_radio_pipe" callExtension _request;
	};
	TF_tangent_lr_pressed = false;
};
true