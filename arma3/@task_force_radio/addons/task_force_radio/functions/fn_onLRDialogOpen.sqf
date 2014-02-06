private ["_dialog_to_open", "_radio"];
[] spawn {
	sleep 0.1;

	if ((alive player) and {call TFAR_fnc_haveLRRadio}) then {
		if !(dialog) then {
			_dialog_to_open = "rt1523g_radio_dialog";
			_radio = (TF_lr_dialog_radio select 0);

			if (_radio isKindOf "Bag_Base") then {
				_radio = (typeOf _radio);
				_dialog_to_open = getText(configFile >> "CfgVehicles" >> _radio >> "tf_dialog");
			} else {
			
				if (((TF_lr_dialog_radio select 0) call TFAR_fnc_getVehicleSide) == west) then {
					_dialog_to_open = getText(configFile >> "CfgVehicles" >> TF_defaultWestBackpack >> "tf_dialog");
					_radio = TF_defaultWestBackpack;
				} else {
					if (((TF_lr_dialog_radio select 0) call TFAR_fnc_getVehicleSide) == east) then {
						_dialog_to_open = getText(configFile >> "CfgVehicles" >> TF_defaultEastBackpack >> "tf_dialog");
						_radio = TF_defaultEastBackpack;
					} else {
						_dialog_to_open = getText(configFile >> "CfgVehicles" >> TF_defaultGuerBackpack >> "tf_dialog");
						_radio = TF_defaultGuerBackpack;
					};
				};
			};
			
			createDialog _dialog_to_open;
			player playAction "Gear";
			call compile getText(configFile >> "CfgVehicles" >> _radio >> "tf_dialogUpdate");
		};
	};
};
true