if ((alive TFAR_currentUnit) and {call TFAR_fnc_haveDDRadio}) then {
	if !(dialog) then {
		createDialog "diver_radio_dialog";
		TFAR_currentUnit playAction "Gear";
		call TFAR_fnc_updateDDDialog;
		["OnRadioOpen", player, [player, "DDRadio", false, "diver_radio_dialog", true]] call TFAR_fnc_fireEventHandlers;
	};
};
true
