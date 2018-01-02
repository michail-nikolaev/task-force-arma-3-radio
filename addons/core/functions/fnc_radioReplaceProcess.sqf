#include "script_component.hpp"

/*
 * Name: TFAR_fnc_radioReplaceProcess
 *
 * Author: NKey, Dorbedo
 * Replaces a player's radios if there are any prototype radios.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [TFAR_fnc_radioReplaceProcess, 2] call CBA_fnc_addPerFrameHandler;
 *
 * Public: Yes
 */

if !(GVAR(SettingsInitialized)) exitWith {};

if (GVAR(use_saved_sr_setting) && {isNil QGVAR(saved_active_sr_settings)}) then {
    if ((alive TFAR_currentUnit) && {call TFAR_fnc_haveSWRadio}) then {
        private _active_sr_radio = call TFAR_fnc_activeSwRadio;
        if !(isNil "_active_sr_radio") then {
            GVAR(saved_active_sr_settings) = _active_sr_radio call DFUNC(getSwSettings);
        };
    };
};

if (GVAR(use_saved_lr_setting) && {isNil QGVAR(saved_active_lr_settings)}) then {
    if ((alive TFAR_currentUnit) && {call TFAR_fnc_haveLRRadio}) then {
        private _active_lr_radio = call TFAR_fnc_activeLrRadio;
        if !(isNil "_active_lr_radio") then {
            GVAR(saved_active_lr_settings) = _active_lr_radio call DFUNC(getLrSettings);
        };
    };
};

if ((time - TF_respawnedAt > 5) and {alive TFAR_currentUnit}) then {
    false call DFUNC(requestRadios);
};
