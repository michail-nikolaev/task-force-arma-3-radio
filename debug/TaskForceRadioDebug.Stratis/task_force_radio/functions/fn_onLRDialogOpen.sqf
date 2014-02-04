private ["_dialog_to_open", "_radio"];
[] spawn {
	sleep 0.1;

	if ((alive player) and {call TFAR_fnc_haveLRRadio}) then {
		if !(dialog) then {
			_dialog_to_open = "rt1523g_radio_dialog";
			_radio = (TF_lr_dialog_radio select 0);

			if (_radio isKindOf "Bag_Base") then {
				_dialog_to_open = getText(configFile >> "CfgVehicles" >> (typeOf _radio) >> "tf_dialog");
			} else {
				if (((TF_lr_dialog_radio select 0) call TFAR_fnc_getVehicleSide) == west) then {
					_dialog_to_open = "rt1523g_radio_dialog";
				} else {
					if (((TF_lr_dialog_radio select 0) call TFAR_fnc_getVehicleSide) == east) then {
						_dialog_to_open = "mr3000_radio_dialog";
					} else {
						_dialog_to_open = "anprc155_radio_dialog";
					};
				};
			};
			
			createDialog _dialog_to_open;
			player playAction "Gear";
			call compile getText(configFile >> "CfgVehicles" >> (typeOf _radio) >> "tf_dialogUpdate");
		};
	};
};
true