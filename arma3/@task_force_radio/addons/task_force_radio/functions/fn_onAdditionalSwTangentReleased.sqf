private ["_freq"];
if ((TF_tangent_sw_pressed) and {alive TFAR_currentUnit}) then {
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	if ((_radio call TFAR_fnc_getAdditionalSwChannel) > -1) then {
		_freq = [_radio, (_radio call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency;
		["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, true, false]] call TFAR_fnc_fireEventHandlers;
		[format[localize "STR_additional_transmit_end",format ["%1<img size='1.5' image='%2'/>", getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName"), getText(configFile >> "CfgWeapons"  >> _radio >> "picture")], (_radio call TFAR_fnc_getAdditionalSwChannel) + 1,  _freq],
		format["TANGENT	RELEASED	%1%2	%3	%4", _freq, (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode, getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range") * (call TFAR_fnc_getTransmittingDistanceMultiplicator), getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")]
		] call TFAR_fnc_ProcessTangent;
		TF_tangent_sw_pressed = false;
		//						unit, radio, radioType, additional, buttonDown
		["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, true, false]] call TFAR_fnc_fireEventHandlers;
	};
};
false