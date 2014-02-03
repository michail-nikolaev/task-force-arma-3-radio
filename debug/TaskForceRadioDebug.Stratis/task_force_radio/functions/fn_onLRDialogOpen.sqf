private ["_dialog_to_open"];
[] spawn {
	sleep 0.1;

	if ((alive player) and {call TFAR_fnc_haveLRRadio}) then {
		if !(dialog) then {
			_dialog_to_open = "rt1523g_radio_dialog";

			if ((TF_lr_dialog_radio select 0) isKindOf "Bag_Base") then {
				_dialog_to_open = getText(configFile >> "CfgVehicles" >> typeOf(TF_lr_dialog_radio select 0) >> "tf_dialog");
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
			call TFAR_fnc_updateLRDialogToChannel;
		}
	};
};
true