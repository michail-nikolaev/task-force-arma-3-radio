private["_result", "_request", "_hintText"];
if (time - TF_last_dd_tangent_press > 0.1) then {
	if (!(TF_tangent_dd_pressed) and {alive currentUnit} and {call TFAR_fnc_haveDDRadio}) then {
		if (call TFAR_fnc_isAbleToUseRadio) then {
			call TFAR_fnc_unableToUseHint;
		} else {
			if ([currentUnit call TFAR_fnc_eyeDepth, currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside] call TFAR_fnc_canUseDDRadio) then {
				[format[localize "STR_transmit", "DD", "1", TF_dd_frequency], format["TANGENT_DD	PRESSED	%1	0	dd", TF_dd_frequency], -1] call TFAR_fnc_ProcessTangent;
				TF_tangent_dd_pressed = true;
				//						unit, radio, radioType, additional, buttonDown
				["OnTangent", currentUnit, [currentUnit, "DD", 2, false, true]] call TFAR_fnc_fireEventHandlers;
			} else {
				call TFAR_fnc_onGroundHint;
			}
		};	
	};
};
TF_last_dd_tangent_press = time;
true
