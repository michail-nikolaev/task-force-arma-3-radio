// server
["TF_no_auto_long_range_radio", "CHECKBOX", localize "STR_radio_no_auto_long_range_radio", "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TF_give_personal_radio_to_regular_soldier", "CHECKBOX", localize "STR_radio_give_personal_radio_to_regular_soldier", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TF_give_microdagr_to_soldier", "CHECKBOX", localize "STR_radio_give_microdagr_to_soldier", "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TF_same_sw_frequencies_for_side", "CHECKBOX", localize "STR_radio_same_sw_frequencies_for_side", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TF_same_lr_frequencies_for_side", "CHECKBOX", localize "STR_radio_same_lr_frequencies_for_side", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TF_same_dd_frequencies_for_side", "CHECKBOX", localize "STR_radio_same_dd_frequencies_for_side", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
// client
["TF_default_radioVolume", "SLIDER", localize "STR_radio_default_radioVolume", "Task Force Arrowhead Radio", [1, 9, 9, 0]] call CBA_Settings_fnc_init;
