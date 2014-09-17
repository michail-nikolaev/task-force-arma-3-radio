/*
 	Name: TFAR_fnc_radioReplaceProcess
 	
 	Author(s):
		NKey

 	Description:
		Replaces a player's radios if there are any prototype radios.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		[] spawn TFAR_fnc_radioReplaceProcess;
*/
private ["_currentPlayerFlag", "_active_sw_radio", "_active_lr_radio", "_set"];
while {true} do {
	currentUnit = call TFAR_fnc_currentUnit;	
	if ((isNil "previousCurrentUnit") or {previousCurrentUnit != currentUnit}) then {
		previousCurrentUnit = currentUnit;		
		_set = (currentUnit getVariable "tf_handlers_set");
		if (isNil "_set") then {			
			currentUnit addEventHandler ["Take", {
				private "_class";				
				_class = ConfigFile >> "CfgWeapons" >> (_this select 2);
				if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
					[(_this select 2), getPlayerUID player] call TFAR_fnc_setRadioOwner;
				};
			}];
			currentUnit addEventHandler ["Put", {
				private "_class";				
				_class = ConfigFile >> "CfgWeapons" >> (_this select 2);
				if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
					[(_this select 2), ""] call TFAR_fnc_setRadioOwner;
				};
			}];			
			currentUnit setVariable ["tf_handlers_set", true];
		};

	};
	
	if !(TF_use_saved_sw_setting) then {
		if ((alive currentUnit) and (call TFAR_fnc_haveSWRadio)) then {
			_active_sw_radio = call TFAR_fnc_activeSwRadio;
			if !(isNil "_active_sw_radio") then {
				TF_saved_active_sw_settings = _active_sw_radio call TFAR_fnc_getSwSettings;
			} else {
				TF_saved_active_sw_settings = nil;	
			};
		} else {
			TF_saved_active_sw_settings = nil;	
		};
	};

	if !(TF_use_saved_lr_setting) then {
		if ((alive currentUnit) and (call TFAR_fnc_haveLRRadio)) then {
			_active_lr_radio = call TFAR_fnc_activeLrRadio;
			if !(isNil "_active_lr_radio") then {
				TF_saved_active_lr_settings = _active_lr_radio call TFAR_fnc_getLrSettings;
			} else {
				TF_saved_active_lr_settings = nil;	
			};
		} else {
			TF_saved_active_lr_settings = nil;	
		};
	};

	sleep 2;
	if ((time - TF_respawnedAt > 10) and (alive currentUnit)) then {
		false call TFAR_fnc_requestRadios;
	};
	if !(isNull currentUnit) then {
		_currentPlayerFlag = currentUnit getVariable "tf_force_radio_active";
		if (isNil "_currentPlayerFlag") then {
			currentUnit setVariable ["tf_force_radio_active", TF_ADDON_VERSION, true];
		};
	}
};