[] spawn {
    private ["_radio","_dialog_to_open","_dialog_update"];
    sleep 0.1;

	if ((alive TFAR_currentUnit) and {call TFAR_fnc_haveLRRadio}) then {
		if !(dialog) then {
			_radio = (TF_lr_dialog_radio select 0);
			_dialog_to_open = ([_radio, "tf_dialog"] call TFAR_fnc_getLrRadioProperty);
			_dialog_update = ([_radio, "tf_dialogUpdate"] call TFAR_fnc_getLrRadioProperty);

			createDialog _dialog_to_open;
			TFAR_currentUnit playAction "Gear";
			call compile _dialog_update;
            ["OnRadioOpen", player, [player, TF_lr_dialog_radio, true, _dialog_to_open, true]] call TFAR_fnc_fireEventHandlers;
		};
	};
};
true
