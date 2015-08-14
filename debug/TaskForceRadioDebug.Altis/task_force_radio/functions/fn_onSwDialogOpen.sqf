[] spawn {
	sleep 0.1;
<<<<<<< HEAD
	if ((alive TFAR_currentUnit) and {!(isNil "TF_sw_dialog_radio")} and {!dialog}) then {
		private ["_dialog_to_open"];
		_dialog_to_open = getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialog");
		createDialog _dialog_to_open;
		TFAR_currentUnit playAction "Gear";
		call compile getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialogUpdate");
		["OnRadioOpen", player, [player, TF_sw_dialog_radio, false, _dialog_to_open, true]] call TFAR_fnc_fireEventHandlers;
	};
};
true
=======
	if ((alive player) and {!(isNil "TF_sw_dialog_radio")} and {!dialog}) then {
		private ["_dialog_to_open"];
		_dialog_to_open = getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialog");
		createDialog _dialog_to_open;
		player playAction "Gear";
		call compile getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialogUpdate");
	};
};
true
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
