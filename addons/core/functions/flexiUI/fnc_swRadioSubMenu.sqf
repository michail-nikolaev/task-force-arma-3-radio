#include "script_component.hpp"

/*
  Name: TFAR_fnc_swRadioSubMenu

  Author: NKey, Garth de Wet (L-H)
    Returns a sub menu for a particular radio.

  Arguments:
    None

  Return Value:
    Flexi-menu <ARRAY>

  Example:
    call TFAR_fnc_swRadioSubMenu;

  Public: No
*/

[
    ["secondary", localize LSTRING(select_action), "buttonList", "", false],
    [
        [localize LSTRING(select_action_setup), "[{call TFAR_fnc_onSwDialogOpen;}, [], 0.2] call CBA_fnc_waitAndExecute;", "", localize LSTRING(select_action_setup_tooltip), "", -1, true, true],
        [localize LSTRING(select_action_use), "TF_sw_dialog_radio call TFAR_fnc_setActiveSwRadio;[(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_showRadioInfo;", "", localize LSTRING(select_action_use_tooltip), "", -1, true, true],
        [localize LSTRING(select_action_copy_settings_from), "", "", localize LSTRING(select_action_copy_settings_from_tooltip), "_this call TFAR_fnc_copyRadioSettingMenu", -1, true, true]
    ]
]
