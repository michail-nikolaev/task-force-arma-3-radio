#include "script_component.hpp"

/*
    Name: TFAR_fnc_radioReplaceProcess

    Author(s):
        NKey, Dorbedo

    Description:
        Replaces a player's radios if there are any prototype radios.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        [TFAR_fnc_radioReplaceProcess, 2] call CBA_fnc_addPerFrameHandler;
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
    private _countPrototypes = {
        private _allItems = (assignedItems _this);
        _allItems append ((getItemCargo (uniformContainer _this)) select 0);
        _allItems append ((getItemCargo (vestContainer _this)) select 0);
        _allItems append ((getItemCargo (backpackContainer _this)) select 0);
        _allItems = _allItems arrayIntersect _allItems;//Remove duplicates

        {
            _x call TFAR_fnc_isPrototypeRadio
        } count _allItems
    };
    
    if( TFAR_currentUnit call _countPrototypes > 0) then {
        private _classes = TFAR_currentUnit call TFAR_fnc_getDefaultRadioClasses;
        [TFAR_currentUnit, _classes select 2] remoteExec ["TFAR_fnc_replaceSwRadiosServer", 2];
    };
};
