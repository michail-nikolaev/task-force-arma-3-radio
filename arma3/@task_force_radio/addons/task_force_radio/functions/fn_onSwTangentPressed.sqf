private["_result", "_request", "_hintText"];
if (!(tangent_sw_pressed) and {alive player} and {call TFAR_fnc_haveSWRadio}) then {
	if ([player, player call TFAR_fnc_vehicleIsIsolatedAndInside, [player, player call TFAR_fnc_vehicleIsIsolatedAndInside] call TFAR_fnc_canSpeak] call TFAR_fnc_canUseSWRadio) then { 
		_hintText = format[localize "STR_transmit_sw", call TFAR_fnc_currentSWFrequency];
		hintSilent parseText (_hintText);
		_request = format["TANGENT	PRESSED	%1%2",call TFAR_fnc_currentSWFrequency, (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode];
		if (isMultiplayer) then {
			_result = "task_force_radio_pipe" callExtension _request;
		};
		tangent_sw_pressed = true;
	} else {
		call inWaterHint;
	};
};
true