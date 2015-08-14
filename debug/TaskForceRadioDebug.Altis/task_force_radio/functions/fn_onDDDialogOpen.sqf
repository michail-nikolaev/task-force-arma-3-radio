<<<<<<< HEAD
if ((alive TFAR_currentUnit) and {call TFAR_fnc_haveDDRadio}) then {
	if !(dialog) then {
		createDialog "diver_radio_dialog";
		TFAR_currentUnit playAction "Gear";
		call TFAR_fnc_updateDDDialog;
		["OnRadioOpen", player, [player, "DDRadio", false, "diver_radio_dialog", true]] call TFAR_fnc_fireEventHandlers;
	};
};
true
=======
if ((alive player) and {call TFAR_fnc_haveDDRadio}) then {
	if !(dialog) then {
		createDialog "diver_radio_dialog";
		player playAction "Gear";
		call TFAR_fnc_updateDDDialog;
	};
};
true
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
