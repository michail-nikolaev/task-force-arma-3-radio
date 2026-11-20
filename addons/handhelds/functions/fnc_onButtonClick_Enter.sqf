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
    [IDC_ANPRC152_EDIT] call TFAR_handhelds_fnc_onButtonClick_Enter;

  Public: No
*/

params [["_ctrlEdit", 0, [0, controlNull]]];

if (IS_NUMBER(_ctrlEdit)) then {
    private _dialog = TF_sw_dialog_radio call TFAR_fnc_getRadioDialogConfig;
    _ctrlEdit = (findDisplay getNumber (_dialog >> "idd")) displayCtrl _ctrlEdit;
};

if (isNull _ctrlEdit) exitWith {};
if ((_ctrlEdit getVariable ["TFAR_frequencyState", ""]) == "name") exitWith {call TFAR_fnc_updateSWDialogToChannel};

private _frequency = TFAR_FREQUENCYSTRING_TO_FREQNUMBER(ctrlText _ctrlEdit);
if ((_frequency >= TFAR_MIN_SW_FREQ) and {_frequency <= TFAR_MAX_SW_FREQ}) then {
    [TF_sw_dialog_radio, QTFAR_ROUND_FREQUENCY(_frequency)] call TFAR_fnc_setSwFrequency;
    ["OnFrequencyChangedFromUI", [TFAR_currentUnit, TF_sw_dialog_radio, QTFAR_ROUND_FREQUENCY(_frequency)]] call TFAR_fnc_fireEventHandlers;
    call TFAR_fnc_hideHint;
} else {
    hint formatText [ARR_3(localize 'STR_TFAR_CORE_incorrect_frequency', TFAR_MIN_SW_FREQ, TFAR_MAX_SW_FREQ)]
};
call TFAR_fnc_updateSWDialogToChannel;
