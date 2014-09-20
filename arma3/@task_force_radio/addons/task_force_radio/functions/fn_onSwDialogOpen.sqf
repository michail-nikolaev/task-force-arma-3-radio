[] spawn {
	sleep 0.1;
	if ((alive currentUnit) and {!(isNil "TF_sw_dialog_radio")} and {!dialog}) then {
		private ["_dialog_to_open"];
		_dialog_to_open = getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialog");
		createDialog _dialog_to_open;
		currentUnit playAction "Gear";
		call compile getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialogUpdate");
	};
};
true