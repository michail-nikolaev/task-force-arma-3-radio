#include "script_component.hpp"

/*
    Name: TFAR_fnc_activeLrRadio

    Author(s):
        NKey

    Description:
        Returns the active LR radio.

    Parameters:
        Nothing

    Returns:
        ARRAY: Active LR radio

    Example:
        _radio = call TFAR_fnc_activeLRRadio;
*/

private _radios = TFAR_currentUnit call TFAR_fnc_lrRadiosList;

if (!isNil "TFAR_OverrideActiveLRRadio") then {
    if (TFAR_currentUnit distance (TFAR_OverrideActiveLRRadio select 0) > TFAR_MAXREMOTELRRADIODISTANCE) then {
        TFAR_OverrideActiveLRRadio = nil;
    } else {
        if (true) exitWith {TFAR_OverrideActiveLRRadio};
    };
};

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
