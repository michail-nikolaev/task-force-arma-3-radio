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

if (!isNil "TFAR_OverrideActiveLRRadio") exitWith {
    if (!(((TFAR_OverrideActiveLRRadio select 0) getVariable [QGVAR(usedExternallyBy), objNull]) isEqualTo TFAR_currentUnit) ||
        {TFAR_currentUnit distance (TFAR_OverrideActiveLRRadio select 0) > TFAR_MAXREMOTELRRADIODISTANCE}) then {

        [] call FUNC(stopExternalUsage);
        call TFAR_fnc_activeLrRadio

    } else {
        TFAR_OverrideActiveLRRadio
    };
};

private _radios = (TFAR_currentUnit call TFAR_fnc_lrRadiosList) select {!(isNull ((_x select 0) getVariable [QGVAR(usedExternallyBy), objNull]))};

if (isNil "TF_lr_active_radio") then {
    TF_lr_active_radio = _radios param [0,nil];
} else {
    private _found = false;
    {
        if (_x isEqualTo TF_lr_active_radio) exitWith {_found = true};
    } count _radios;
    if !(_found) then {
        TF_lr_active_radio = _radios param [0,nil];
    };
};
TF_lr_active_radio
