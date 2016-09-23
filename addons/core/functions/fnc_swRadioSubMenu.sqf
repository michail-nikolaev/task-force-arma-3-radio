/*
 	Name: TFAR_fnc_swRadioSubMenu
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
		Returns a sub menu for a particular radio.
 	
 	Parameters: 
		Nothing
 	
 	Returns:
		ARRAY: CBA UI menu.
 	
 	Example:
		Called internally by CBA UI
*/
private ["_submenu"];
_submenu = 
[
	["secondary", localize "STR_select_action", "buttonList", "", false],
	[
		[localize "STR_select_action_setup", "call TFAR_fnc_onSwDialogOpen;", "", localize "STR_select_action_setup_tooltip", "", -1, true, true],
		[localize "STR_select_action_use", "TF_sw_dialog_radio call TFAR_fnc_setActiveSwRadio;[(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_ShowRadioInfo;", "", localize "STR_select_action_use_tooltip", "", -1, true, true],
		[localize "STR_select_action_copy_settings_from", "", "", localize "STR_select_action_settings_from_tooltip", "_this call TFAR_fnc_copyRadioSettingMenu", -1, true, true]
	]		
];
_submenu