#include "\z\tfar\addons\backpacks\script_component.hpp"

/*
    Name: TFAR_backpacks_fnc_onButtonClick_Enter

    Author(s):


    Description:
        Button "Enter" was pressed

    Parameters:
        0: CONTROL/SCALAR - Edit control or IDC

    Returns:
        Nothing

    Example:
        [TF_lr_dialog_radio displayCtrl IDC_ANPRC152_EDIT] call TFAR_backpacks_fnc_onButtonClick_Enter;

*/

params [["_ctrlEdit", 0, [0, controlNull]]];

If (IS_NUMBER(_ctrlEdit)) then {
    _ctrlEdit = TF_lr_dialog_radio displayCtrl _ctrlEdit;
};

private _frequency = TFAR_FREQUENCYSTRING_TO_FREQNUMBER(ctrlText _edit_IDC);
if ((_frequency >= TFAR_MIN_ASIP_FREQ) and {_frequency <= TFAR_MAX_ASIP_FREQ}) then {
    [TF_lr_dialog_radio, QTFAR_ROUND_FREQUENCY(_frequency)] call TFAR_fnc_setLrFrequency;
    call TFAR_fnc_hideHint;
} else {
    hint formatText [localize 'STR_TFAR_CORE_incorrect_frequency', TFAR_MIN_ASIP_FREQ, TFAR_MAX_ASIP_FREQ];
};
call TFAR_fnc_updateLRDialogToChannel;
