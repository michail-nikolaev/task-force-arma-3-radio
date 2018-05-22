#include "script_component.hpp"

/*
  Name: TFAR_handhelds_fnc_onButtonClick_Enter

  Author: Dorbedo
    Button "Enter" was pressed

  Arguments:
    0: Edit control or IDC <CONTROL/SCALAR>

  Return Value:
    Nothing

  Example:
    [TF_sw_dialog_radio displayCtrl IDC_ANPRC152_EDIT] call TFAR_handhelds_fnc_onButtonClick_Enter;

  Public: No
*/

params [["_ctrlEdit", 0, [0, controlNull]]];

If (IS_NUMBER(_ctrlEdit)) then {
    _ctrlEdit = TF_sw_dialog_radio displayCtrl _ctrlEdit;
};

private _frequency = TFAR_FREQUENCYSTRING_TO_FREQNUMBER(ctrlText _edit_IDC);
if ((_frequency >= TFAR_MIN_SW_FREQ) and {_frequency <= TFAR_MAX_SW_FREQ}) then {
    [TF_sw_dialog_radio, QTFAR_ROUND_FREQUENCY(_frequency)] call TFAR_fnc_setSwFrequency;
    call TFAR_fnc_hideHint;
} else {
    hint formatText [ARR_3(localize 'STR_TFAR_CORE_incorrect_frequency', TFAR_MIN_SW_FREQ, TFAR_MAX_SW_FREQ)]
};
call TFAR_fnc_updateSWDialogToChannel;
