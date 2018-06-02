#include "script_component.hpp"

if (!(alive TFAR_currentUnit) or {!(call TFAR_fnc_haveLRRadio)} or {dialog}) exitWith {};

private _radio = (TF_lr_dialog_radio select 0);
private _dialog_to_open = ([_radio, "tf_dialog"] call TFAR_fnc_getLrRadioProperty);
private _dialog_update = ([_radio, "tf_dialogUpdate"] call TFAR_fnc_getLrRadioProperty);
private _externalUser = _radio getVariable [QGVAR(usedExternallyBy), objNull];

if !((_externalUser isEqualTo objNull) || {_externalUser isEqualTo TFAR_currentUnit}) then {
    [QGVARMAIN(stopExternalUsage), [], _radio getVariable [QGVAR(usedExternallyBy), objNull]] call CBA_fnc_targetEvent;
};

createDialog _dialog_to_open;
TFAR_currentUnit playAction "Gear";
call compile _dialog_update;
["OnRadioOpen", [player, TF_lr_dialog_radio, true, _dialog_to_open, true]] call TFAR_fnc_fireEventHandlers;

true
