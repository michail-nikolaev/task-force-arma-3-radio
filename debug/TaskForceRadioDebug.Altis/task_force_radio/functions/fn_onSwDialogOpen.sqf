[] spawn {
	sleep 0.1;
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
