private["_result", "_request", "_hintText", "_depth"];
if (!(TF_tangent_sw_pressed) and {alive player} and {call TFAR_fnc_haveSWRadio}) then {	
	if (call TFAR_fnc_isAbleToUseRadio) then {
		call TFAR_fnc_unableToUseHint;
	} else {
		_depth = player call TFAR_fnc_eyeDepth;
		if ([player, player call TFAR_fnc_vehicleIsIsolatedAndInside, [player call TFAR_fnc_vehicleIsIsolatedAndInside, _depth] call TFAR_fnc_canSpeak, _depth] call TFAR_fnc_canUseSWRadio) then {
			private "_radio";
			_radio = call TFAR_fnc_activeSwRadio;
			_hintText = format[localize "STR_transmit",format ["%1<img size='1.5' image='%2'/>", getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName"),
				getText(configFile >> "CfgWeapons"  >> _radio >> "picture")],(_radio call TFAR_fnc_getSwChannel) + 1, call TFAR_fnc_currentSWFrequency];
			[parseText (_hintText), -1] call TFAR_fnc_showHint;
			_request = format["TANGENT	PRESSED	%1%2	%3	%4",call TFAR_fnc_currentSWFrequency, _radio call TFAR_fnc_getSwRadioCode, getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range"), getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")];
			if (isMultiplayer) then {
				_result = "task_force_radio_pipe" callExtension _request;
			};
			TF_tangent_sw_pressed = true;
		} else {
			call TFAR_fnc_inWaterHint;
		};
	};
};
true