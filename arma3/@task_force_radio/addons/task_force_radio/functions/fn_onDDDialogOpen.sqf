if ((alive player) and {call TFAR_fnc_haveDDRadio}) then {
	if !(dialog) then {
		createDialog "diver_radio_dialog";
		player playAction "Gear";
		call TFAR_fnc_updateDDDialog;
	};
};
true