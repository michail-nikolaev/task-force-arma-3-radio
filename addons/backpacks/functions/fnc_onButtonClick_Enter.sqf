#include "script_component.hpp"

/*
  Name: TFAR_backpacks_fnc_onButtonClick_Enter

  Author: Dorbedo
    Button "Enter" was pressed

  Arguments:
    0: Edit control or IDC <CONTROL/SCALAR>

  Return Value:
    Nothing

  Example:
    [IDC_ANPRC152_EDIT] call TFAR_backpacks_fnc_onButtonClick_Enter;

  Public: No
*/

params [["_ctrlEdit", 0, [0, controlNull]]];

if (IS_NUMBER(_ctrlEdit)) then {
    private _dialog = TF_lr_dialog_radio call TFAR_fnc_getRadioDialogConfig;
    _ctrlEdit = (findDisplay getNumber (_dialog >> "idd")) displayCtrl _ctrlEdit;
};

if (isNull _ctrlEdit) exitWith {};
if ((_ctrlEdit getVariable ["TFAR_frequencyState", ""]) == "name") exitWith {call TFAR_fnc_updateLRDialogToChannel};

private _frequency = TFAR_FREQUENCYSTRING_TO_FREQNUMBER(ctrlText _ctrlEdit);
if !(_frequency >= TFAR_MIN_ASIP_FREQ && {_frequency <= TFAR_MAX_ASIP_FREQ}) exitWith {
    hint formatText [localize 'STR_TFAR_CORE_incorrect_frequency', TFAR_MIN_ASIP_FREQ, TFAR_MAX_ASIP_FREQ];
    if ((_ctrlEdit getVariable ["TFAR_frequencyState", ""]) == "editing") then {
        ctrlSetFocus _ctrlEdit;
    } else {
        call TFAR_fnc_updateLRDialogToChannel;
    };
};
[TF_lr_dialog_radio, QTFAR_ROUND_FREQUENCY(_frequency)] call TFAR_fnc_setLrFrequency;
["OnFrequencyChangedFromUI", [TFAR_currentUnit, TF_lr_dialog_radio, QTFAR_ROUND_FREQUENCY(_frequency)]] call TFAR_fnc_fireEventHandlers;
call TFAR_fnc_hideHint;
call TFAR_fnc_updateLRDialogToChannel;
