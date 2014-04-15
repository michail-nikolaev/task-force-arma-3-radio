private["_result", "_request", "_hintText"];
if (call TFAR_fnc_isAbleToUseRadio) then {
	call TFAR_fnc_unableToUseHint;
} else {
	if (!(TF_tangent_dd_pressed) and {alive player} and {call TFAR_fnc_haveDDRadio}) then {
		if ([player call TFAR_fnc_eyeDepth, player call TFAR_fnc_vehicleIsIsolatedAndInside] call TFAR_fnc_canUseDDRadio) then {
			[format[localize "STR_transmit", "DD", "1", TF_dd_frequency], format["TANGENT_DD	PRESSED	%1	0	dd", TF_dd_frequency], -1] call TFAR_fnc_ProcessTangent;
			TF_tangent_dd_pressed = true;
		} else {
			call TFAR_fnc_onGroundHint;
		}
	};	
};
true