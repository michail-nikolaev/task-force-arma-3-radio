private["_result", "_request", "_hintText"];
if (!(tangent_dd_pressed) and {alive player} and {call TFAR_fnc_haveDDRadio}) then {
	if ([player, player call TFAR_fnc_vehicleIsIsolatedAndInside] call TFAR_fnc_canUseDDRadio) then { 
		_hintText = format[localize "STR_transmit_dd", dd_frequency];
		hintSilent parseText (_hintText);
		_request = format["TANGENT_DD	PRESSED	%1", dd_frequency];
		if (isMultiplayer) then {
			_result = "task_force_radio_pipe" callExtension _request;
		};
		tangent_dd_pressed = true;
	} else {
		call TFAR_fnc_onGroundHint;
	}
};
true