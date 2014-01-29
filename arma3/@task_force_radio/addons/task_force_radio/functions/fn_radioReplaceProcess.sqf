private ["_currentPlayerFlag", "_active_sw_radio", "_active_lr_radio"];
while {true} do {
	if !(use_saved_sw_setting) then {
		if ((alive player) and (call TFAR_fnc_haveSWRadio)) then {
			_active_sw_radio = call TFAR_fnc_activeSwRadio;
			if !(isNil "_active_sw_radio") then {
				saved_active_sw_settings = _active_sw_radio call TFAR_fnc_getSwSettings;
			} else {
				saved_active_sw_settings = nil;	
			};
		} else {
			saved_active_sw_settings = nil;	
		};
	};

	if !(use_saved_lr_setting) then {
		if ((alive player) and (call TFAR_fnc_haveLRRadio)) then {
			_active_lr_radio = call TFAR_fnc_activeLrRadio;
			if !(isNil "_active_lr_radio") then {
				saved_active_lr_settings = _active_lr_radio call TFAR_fnc_getLrSettings;
			} else {
				saved_active_lr_settings = nil;	
			};
		} else {
			saved_active_lr_settings = nil;	
		};
	};

	sleep 2;
	if ((time - respawnedAt > 10) and (alive player)) then {
		false call TFAR_fnc_requestRadios;
	};
	if !(isNull player) then {
		_currentPlayerFlag = player getVariable "tf_force_radio_active";
		if (isNil "_currentPlayerFlag") then {
			player setVariable ["tf_force_radio_active", TF_ADDON_VERSION, true];
		};
	}
};