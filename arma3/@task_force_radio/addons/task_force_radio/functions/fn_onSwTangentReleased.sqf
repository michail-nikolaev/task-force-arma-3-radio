private ["_radio"];
<<<<<<< HEAD
if ((TF_tangent_sw_pressed) and {alive TFAR_currentUnit}) then {
	_radio = call TFAR_fnc_activeSwRadio;
	
	["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers;
	
=======
if ((TF_tangent_sw_pressed) and {alive player}) then {
	_radio = call TFAR_fnc_activeSwRadio;
	
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	[format[localize "STR_transmit_end",format ["%1<img size='1.5' image='%2'/>", getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName"),
		getText(configFile >> "CfgWeapons"  >> _radio >> "picture")],(_radio call TFAR_fnc_getSwChannel) + 1, call TFAR_fnc_currentSWFrequency],
	format["TANGENT	RELEASED	%1%2	%3	%4",call TFAR_fnc_currentSWFrequency, (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode, getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range") * (call TFAR_fnc_getTransmittingDistanceMultiplicator), getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")]
	] call TFAR_fnc_ProcessTangent;
	
	TF_tangent_sw_pressed = false;
<<<<<<< HEAD
	//						unit, radio, radioType, additional, buttonDown
	["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers;
=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
true