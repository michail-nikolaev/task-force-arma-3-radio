private["_result", "_request"];
if ((TF_tangent_dd_pressed) and {alive player}) then {
	call TFAR_fnc_hideHint;
	_request = format["TANGENT_DD	RELEASED	%1", TF_dd_frequency];
	if (isMultiplayer) then {
		_result = "task_force_radio_pipe" callExtension _request;
	};
	TF_tangent_dd_pressed = false;
};
true