private ["_menuDef","_positions","_active_radio","_submenu","_command","_pos","_menu","_position"];
_menu = [];
if (count (call TFAR_fnc_lrRadiosList) > 1) then {
	_menuDef = ["main", localize "STR_select_lr_radio", "buttonList", "", false];
	_positions = [];
	_pos = 0;
	{
		_command = format["TF_lr_dialog_radio = (call TFAR_fnc_lrRadiosList) select %1;call TFAR_fnc_onLrDialogOpen;", _pos];
		_submenu = "";
		_active_radio = call TFAR_fnc_activeLrRadio;
		if (((_x select 0) != (_active_radio select 0)) or ((_x select 1) != (_active_radio select 1))) then {
			_command = format["TF_lr_dialog_radio = (call TFAR_fnc_lrRadiosList) select %1;", _pos];
			_submenu = "_this call TFAR_fnc_lrRadioSubMenu";
		};
		_position = [
			getText(configFile >> "CfgVehicles"  >> typeof(_x select 0) >> "displayName"), 
			_command, 
			getText(configFile >> "CfgVehicles"  >> typeof(_x select 0) >> "picture"),
			"",
			_submenu,
			-1,
			true,
			true
		];
		_positions set [count _positions, _position];
		_pos = _pos + 1;
	} count (call TFAR_fnc_lrRadiosList);
	_menu =
	[
		_menuDef,
		_positions	
	];
} else {
	if (call TFAR_fnc_haveLRRadio) then {
		TF_lr_dialog_radio = call TFAR_fnc_activeLrRadio;
		call TFAR_fnc_onLrDialogOpen;
	};
};
_menu