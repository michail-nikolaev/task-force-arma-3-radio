#include "script_component.hpp"

/*
  Name: TFAR_fnc_activeLrRadio

  Author: NKey
    Returns the active LR radio.

  Arguments:
    None

  Return Value:
    active LR radio <ARRAY>

  Example:
    _radio = call TFAR_fnc_activeLRRadio;

  Public: Yes
*/

if (canSuspend) exitWith {
    private _ret = "";
    isNil {_ret = call TFAR_fnc_activeLrRadio};
    _ret
};

private _radios = TFAR_currentUnit call TFAR_fnc_lrRadiosList;

if (isNil "TF_lr_active_radio") then {
    TF_lr_active_radio = _radios param [0,nil];
} else {
    private _found = _radios findIf {_x isEqualTo TF_lr_active_radio};
    if (_found == -1) then {
        TF_lr_active_radio = _radios param [0,nil];
    };
};

if (!isNil "TFAR_OverrideActiveLRRadio") exitWith {
    private _radioObject = TFAR_OverrideActiveLRRadio select 0;
    private _distObject = [objectParent _radioObject, _radioObject] select isNull objectParent _radioObject;

    if (TFAR_currentUnit distance _distObject > TFAR_MAXREMOTELRRADIODISTANCE) then {
        TFAR_OverrideActiveLRRadio = nil;
        TF_lr_active_radio
    } else {
        TFAR_OverrideActiveLRRadio
    };
};

TF_lr_active_radio
