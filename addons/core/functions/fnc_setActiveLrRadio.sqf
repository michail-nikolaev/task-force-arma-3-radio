#include "script_component.hpp"

/*
  Name: TFAR_fnc_setActiveLrRadio

  Author: NKey
    Sets the active LR radio to the passed radio

  Arguments:
    0: Radio <OBJECT>
    1: Radio ID <OBJECT>

  Return Value:
    None

  Example:
    TF_lr_dialog_radio call TFAR_fnc_setActiveLrRadio;

  Public: Yes
 */
private _old = TF_lr_active_radio;
TF_lr_active_radio = _this;
if (TFAR_currentUnit == player) then {
    TF_lr_active_curator_radio = _this;
};
["OnLRChange", [TFAR_currentUnit, TF_lr_active_radio, _old]] call TFAR_fnc_fireEventHandlers;
