#include "script_component.hpp"

/*
    Name: TFAR_fnc_initialiseEnforceUsageModule

    Author(s):
        L-H

    Description:
        Initialises variables based on module settings.

    Parameters:

    Returns:
        Nothing

    Example:

 */

params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

if (_activated) then {
    ["CBA_beforeSettingsInitialized", {
        _thisArgs params ["_NoLRRadio","_GivePRRadio","_fullDuplex","_sameSWFreq","_sameLRFreq"];
        ["CBA_settings_setSettingMission", ["TF_no_auto_long_range_radio",_NoLRRadio,true]] call CBA_fnc_localEvent;
        ["CBA_settings_setSettingMission", ["TF_give_personal_radio_to_regular_soldier",_GivePRRadio,true]] call CBA_fnc_localEvent;
        ["CBA_settings_setSettingMission", ["TF_full_duplex",_fullDuplex,true]] call CBA_fnc_localEvent;
        ["CBA_settings_setSettingMission", ["tf_same_sw_frequencies_for_side",_sameSWFreq,true]] call CBA_fnc_localEvent;
        ["CBA_settings_setSettingMission", ["tf_same_lr_frequencies_for_side",_sameLRFreq,true]] call CBA_fnc_localEvent;
        ["CBA_beforeSettingsInitialized",_thisId] call CBA_fnc_removeEventHandler;
    },[
        !(_logic getVariable "TeamLeaderRadio"),
        !(_logic getVariable "RiflemanRadio"),
        (_logic getVariable "full_duplex"),
        (_logic getVariable "same_sw_frequencies_for_side"),
        (_logic getVariable "same_lr_frequencies_for_side")
    ]] call CBA_fnc_addEventHandlerArgs;

    TF_terrain_interception_coefficient = (_logic getVariable "terrain_interception_coefficient");
    tf_radio_channel_name = (_logic getVariable "radio_channel_name");
    tf_radio_channel_password = (_logic getVariable "radio_channel_password");
};

true
