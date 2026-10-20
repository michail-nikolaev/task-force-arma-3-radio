#include "script_component.hpp"

/*
  Name: TFAR_fnc_refreshRadioDialogFrequency

  Author: Darojax
    Refreshes open radio dialogs after a frequency-name table changes, keeping
    each model's channel format and preserving unfinished frequency edits.

  Arguments:
    None

  Return Value:
    None

  Public: No
*/

if (!hasInterface) exitWith {};
disableSerialization;

{
    _x params ["_radio", "_isLrRadio"];
    if (_radio isEqualTo "" || {_radio isEqualTo []}) exitWith {};

    private _source = if (_isLrRadio) then {_radio select 0} else {_radio};
    private _getProperty = [TFAR_fnc_getWeaponConfigProperty, TFAR_fnc_getLrRadioProperty] select _isLrRadio;
    private _dialogIdd = [_source, "tf_channelNameDialogIdd", -1] call _getProperty;
    if !(_dialogIdd isEqualType 0) exitWith {};
    if (_dialogIdd < 0) exitWith {};

    private _frequencyControl = (findDisplay _dialogIdd) displayCtrl ([SW_EDIT, LR_EDIT] select _isLrRadio);
    if (isNull _frequencyControl) exitWith {};
    if (_frequencyControl getVariable ["TFAR_frequencyEditing", false]) exitWith {};

    private _dialogUpdate = [_source, "tf_dialogUpdate", ""] call _getProperty;
    [] call compile _dialogUpdate;
} forEach [
    [missionNamespace getVariable ["TF_sw_dialog_radio", ""], false],
    [missionNamespace getVariable ["TF_lr_dialog_radio", []], true]
];
