private["_result", "_request", "_hintText"];
if (!(TF_tangent_lr_pressed) and {alive player} and {call TFAR_fnc_haveLRRadio}) then {
	if ([player, player call TFAR_fnc_vehicleIsIsolatedAndInside] call TFAR_fnc_canUseLRRadio) then {
		private "_radio";
		_radio = call TFAR_fnc_activeLrRadio;
		
		_hintText = format[localize "STR_transmit",format ["%1<img size='1.5' image='%2'/>",[_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty,
			getText(configFile >> "CfgVehicles"  >> typeof (_radio select 0) >> "picture")],(_radio call TFAR_fnc_getLrChannel) + 1, call TFAR_fnc_currentLRFrequency];
		[parseText (_hintText), -1] call TFAR_fnc_showHint;
		_request = format["TANGENT_LR	PRESSED	%1%2", call TFAR_fnc_currentLRFrequency, _radio call TFAR_fnc_getLrRadioCode];
		if (isMultiplayer) then {
			_result = "task_force_radio_pipe" callExtension _request;
		};
		TF_tangent_lr_pressed = true;
	} else {
		call TFAR_fnc_inWaterHint;
	}
};
true