private ["_dialog_to_open"];
[] spawn {
	sleep 0.1;

	if ((alive player) and {call TFAR_fnc_haveLRRadio}) then {
		if !(dialog) then {
			_dialog_to_open = "rt1523g_radio_dialog";

			if ((lr_dialog_radio select 0) isKindOf "Bag_Base") then {				
				if (typeOf(lr_dialog_radio select 0) == "tf_rt1523g") then {
					_dialog_to_open = "rt1523g_radio_dialog";
				};
				if (typeOf(lr_dialog_radio select 0) == "tf_anprc155") then {
					_dialog_to_open = "anprc155_radio_dialog";
				};
				if (typeOf(lr_dialog_radio select 0) == "tf_mr3000") then {
					_dialog_to_open = "mr3000_radio_dialog";
				};
			} else {
				if (((lr_dialog_radio select 0) call TFAR_fnc_getVehicleSide) == west) then {
					_dialog_to_open = "rt1523g_radio_dialog";
				} else {
					if (((lr_dialog_radio select 0) call TFAR_fnc_getVehicleSide) == east) then {
						_dialog_to_open = "mr3000_radio_dialog";
					} else {
						_dialog_to_open = "anprc155_radio_dialog";
					};
				};
			};
			
			createDialog _dialog_to_open;
			call TFAR_fnc_updateLRDialogToChannel;
		}
	};
};
true