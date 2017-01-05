#include "script_component.hpp"

/*
    Name: TFAR_fnc_radioReplaceProcess

    Author(s):
        NKey

    Description:
        Replaces a player's radios if there are any prototype radios.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        [TFAR_fnc_radioReplaceProcess, 2] call CBA_fnc_addPerFrameHandler;
*/

if !(TF_use_saved_sw_setting) then {
    if ((alive TFAR_currentUnit) and (call TFAR_fnc_haveSWRadio)) then {
        private _active_sw_radio = call TFAR_fnc_activeSwRadio;
        if !(isNil "_active_sw_radio") then {
            TF_saved_active_sw_settings = _active_sw_radio call TFAR_fnc_getSwSettings;
        } else {
            TF_saved_active_sw_settings = nil;
        };
    } else {
        TF_saved_active_sw_settings = nil;
    };
};

if !(TF_use_saved_lr_setting) then {
    if ((alive TFAR_currentUnit) and (call TFAR_fnc_haveLRRadio)) then {
        private _active_lr_radio = call TFAR_fnc_activeLrRadio;
        if !(isNil "_active_lr_radio") then {
            TF_saved_active_lr_settings = _active_lr_radio call TFAR_fnc_getLrSettings;
        } else {
            TF_saved_active_lr_settings = nil;
        };
    } else {
        TF_saved_active_lr_settings = nil;
    };
};

if ((time - TF_respawnedAt > 5) and {alive TFAR_currentUnit}) then {
    false call TFAR_fnc_requestRadios;
};
