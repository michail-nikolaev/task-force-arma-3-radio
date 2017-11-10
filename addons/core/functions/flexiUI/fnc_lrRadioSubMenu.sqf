#include "script_component.hpp"

[
    ["secondary", localize LSTRING(select_action), "buttonList", "", false],
    [
        [localize LSTRING(select_action_setup), "[{call TFAR_fnc_onLrDialogOpen;}, [], 0.2] call CBA_fnc_waitAndExecute;", "", localize LSTRING(select_action_setup_tooltip), "", -1, true, true],
        [localize LSTRING(select_action_use), "TF_lr_dialog_radio call TFAR_fnc_setActiveLrRadio;[(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_showRadioInfo;", "", localize LSTRING(select_action_use_tooltip), "", -1, true, true]
    ]
]
