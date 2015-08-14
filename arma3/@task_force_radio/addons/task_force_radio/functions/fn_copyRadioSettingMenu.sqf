/*
 	Name: TFAR_fnc_copyRadioSettingMenu
 	
 	Author(s):
		NKey		
 	
 	Description:
		Returns a sub menu for radio settings copying.
 	
 	Parameters: 
		Nothing
 	
 	Returns:
		ARRAY: CBA UI menu.
 	
 	Example:
		Called internally by CBA UI
*/
private ["_menuDef","_positions","_command","_menu","_position"];
_menu = [];

_menuDef = ["main", localize "STR_select_action_copy_settings_from", "buttonList", "", false];
_positions = [];
{
	if (((_x call TFAR_fnc_getSwRadioCode) == (TF_sw_dialog_radio call TFAR_fnc_getSwRadioCode)) and {TF_sw_dialog_radio != _x}) then {
		_command = format["['%1',TF_sw_dialog_radio] call TFAR_fnc_CopySettings;", _x];		
		_position = [
			getText(configFile >> "CfgWeapons"  >> _x >> "displayName"), 
			_command, 
			getText(configFile >> "CfgWeapons"  >> _x >> "picture"),
			"",
			"",
			-1,
			true,
			true
		];
		_positions set [count _positions, _position];
	};
} forEach (TFAR_currentUnit call TFAR_fnc_radiosList);
_menu =
[
	_menuDef,
	_positions	
];
_menu