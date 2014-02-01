[] spawn {
	sleep 0.1;
	if ((alive player) and {!(isNil "TF_sw_dialog_radio")} and {!dialog}) then {
		if (([TF_sw_dialog_radio, "tf_anprc152_"] call CBA_fnc_find) == 0) then {
			createDialog "anprc152_radio_dialog";
		};
		if (([TF_sw_dialog_radio, "tf_anprc148jem_"] call CBA_fnc_find) == 0) then {
			createDialog "anprc148jem_radio_dialog";
		};
		if (([TF_sw_dialog_radio, "tf_fadak_"] call CBA_fnc_find) == 0) then {
			createDialog "fadak_radio_dialog";
		};

		call TFAR_fnc_updateSWDialogToChannel;
	};
};
true