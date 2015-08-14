<<<<<<< HEAD
if ((TF_tangent_dd_pressed) and {alive TFAR_currentUnit}) then {
	["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, "DD", 2, false, false]] call TFAR_fnc_fireEventHandlers;
	[format[localize "STR_transmit_end", "DD", "1", TF_dd_frequency], format["TANGENT_DD	RELEASED	%1	0	dd", TF_dd_frequency]] call TFAR_fnc_ProcessTangent;
	TF_tangent_dd_pressed = false;
	//						unit, radio, radioType, additional, buttonDown
	["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, "DD", 2, false, false]] call TFAR_fnc_fireEventHandlers;
=======
if ((TF_tangent_dd_pressed) and {alive player}) then {
	[format[localize "STR_transmit_end", "DD", "1", TF_dd_frequency], format["TANGENT_DD	RELEASED	%1	0	dd", TF_dd_frequency]] call TFAR_fnc_ProcessTangent;
	TF_tangent_dd_pressed = false;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
true