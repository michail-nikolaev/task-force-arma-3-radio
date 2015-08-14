private["_result", "_request", "_hintText"];
<<<<<<< HEAD
if (time - TF_last_dd_tangent_press > 0.1) then {
	if (!(TF_tangent_dd_pressed) and {alive TFAR_currentUnit} and {call TFAR_fnc_haveDDRadio}) then {
		if (call TFAR_fnc_isAbleToUseRadio) then {
			call TFAR_fnc_unableToUseHint;
		} else {
			if ([TFAR_currentUnit call TFAR_fnc_eyeDepth, TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside] call TFAR_fnc_canUseDDRadio) then {
				["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, "DD", 2, false, true]] call TFAR_fnc_fireEventHandlers;
				[format[localize "STR_transmit", "DD", "1", TF_dd_frequency], format["TANGENT_DD	PRESSED	%1	0	dd", TF_dd_frequency], -1] call TFAR_fnc_ProcessTangent;
				TF_tangent_dd_pressed = true;
				//						unit, radio, radioType, additional, buttonDown
				["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, "DD", 2, false, true]] call TFAR_fnc_fireEventHandlers;
			} else {
				call TFAR_fnc_onGroundHint;
			}
		};	
	};
};
TF_last_dd_tangent_press = time;
true
=======
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
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
