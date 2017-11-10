#include "script_component.hpp"

#include "XEH_PREP.sqf"

// server
["TFAR_giveLongRangeRadioToGroupLeaders", "CHECKBOX", ELSTRING(settings,radio_auto_long_range_radio), "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TFAR_givePersonalRadioToRegularSoldier", "CHECKBOX", ELSTRING(settings,radio_give_personal_radio_to_regular_soldier), "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TFAR_giveMicroDagrToSoldier", "CHECKBOX", ELSTRING(settings,radio_give_microdagr_to_soldier), "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TFAR_SameSRFrequenciesForSide", "CHECKBOX", ELSTRING(settings,radio_same_sw_frequencies_for_side), "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TFAR_SameLRFrequenciesForSide", "CHECKBOX", ELSTRING(settings,radio_same_lr_frequencies_for_side), "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TFAR_fullDuplex", "CHECKBOX", [ELSTRING(settings,FullDuplex),ELSTRING(settings,FullDuplexDescription)], "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TFAR_enableIntercom", "CHECKBOX", "Enable vehicle Intercom", "Task Force Arrowhead Radio", true, true,{["intercomEnabled",TFAR_enableIntercom] call TFAR_fnc_setPluginSetting;}] call CBA_Settings_fnc_init;
["TFAR_objectInterceptionEnabled", "CHECKBOX", "Enable Object Interception", "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TFAR_spectatorCanHearEnemyUnits", "CHECKBOX", ["Spectator can hear enemy units","If disabled a Spectator can't hear direct speech from Units that are considered Enemy to the Spectators original faction"], "Task Force Arrowhead Radio", true, true,{["spectatorNotHearEnemies",!TFAR_spectatorCanHearEnemyUnits] call TFAR_fnc_setPluginSetting;}] call CBA_Settings_fnc_init;
["TFAR_spectatorCanHearFriendlies", "CHECKBOX", ["Spectator can hear units","If disabled a Spectator can't hear any Players besides other Spectators"], "Task Force Arrowhead Radio", true, true,{["spectatorCanHearFriendlies",TFAR_spectatorCanHearFriendlies] call TFAR_fnc_setPluginSetting;}] call CBA_Settings_fnc_init;
[
    "TFAR_takingRadio",
    "LIST",
    [LSTRING(TAKERADIO_HEADER),LSTRING(TAKERADIO_DESC)],
    "Task Force Arrowhead Radio",
    [[0, 1, 2], [LSTRING(TAKERADIO_0), LSTRING(TAKERADIO_1), LSTRING(TAKERADIO_2)], 2],
    true
] call CBA_Settings_fnc_init;

// client
["TFAR_default_radioVolume", "SLIDER", ELSTRING(settings,radio_default_radioVolume), "Task Force Arrowhead Radio", [1, 9, 7, 0]] call CBA_Settings_fnc_init;
["TFAR_volumeModifier_forceSpeech", "CHECKBOX", [ELSTRING(settings,radio_directSpeechModifier),ELSTRING(settings,radio_directSpeechModifier_desc)], "Task Force Arrowhead Radio", false] call CBA_Settings_fnc_init;
["TFAR_intercomVolume", "SLIDER", ELSTRING(settings,radio_intercomVolume), "Task Force Arrowhead Radio", [0.01, 0.6, 0.3, 3], false, {["intercomVolume",TFAR_intercomVolume] call TFAR_fnc_setPluginSetting;}] call CBA_Settings_fnc_init;
["TFAR_pluginTimeout", "SLIDER", ELSTRING(settings,radio_pluginTimeout), "Task Force Arrowhead Radio", [0.5, 10, 4, 3], false, {["pluginTimeout",TFAR_pluginTimeout] call TFAR_fnc_setPluginSetting;}] call CBA_Settings_fnc_init;
["TFAR_tangentReleaseDelay", "SLIDER", ELSTRING(settings,radio_tangentReleaseDelay), "Task Force Arrowhead Radio", [0, 500, 0, 0], false, {["tangentReleaseDelay",TFAR_tangentReleaseDelay] call TFAR_fnc_setPluginSetting;}] call CBA_Settings_fnc_init;
["TFAR_PosUpdateMode", "LIST", [ELSTRING(settings,radio_positionUpdateMode),ELSTRING(settings,radio_positionUpdateMode_desc)], "Task Force Arrowhead Radio", [[0,0.1,0.2],[ELSTRING(settings,radio_positionUpdateMode_quality),ELSTRING(settings,radio_positionUpdateMode_normal),ELSTRING(settings,radio_positionUpdateMode_performance)],1], false, {}] call CBA_Settings_fnc_init;
["TFAR_ShowVolumeHUD", "CHECKBOX", [ELSTRING(settings,radio_hudVolumeIndicator),ELSTRING(settings,radio_hudVolumeIndicator_desc)], "Task Force Arrowhead Radio", false, false, {if (TFAR_ShowVolumeHUD) then {(QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];} else {(QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];};}] call CBA_Settings_fnc_init;
["TFAR_VolumeHudTransparency", "SLIDER", [ELSTRING(settings,radio_volumeIndicatorTransparency),ELSTRING(settings,radio_volumeIndicatorTransparency_desc)], "Task Force Arrowhead Radio", [0, 1, 0, 3], false, {call TFAR_fnc_updateSpeakVolumeUI;}] call CBA_Settings_fnc_init;
["TFAR_oldVolumeHint", "CHECKBOX", [ELSTRING(settings,radio_useOldVolumeHint),ELSTRING(settings,radio_useOldVolumeHint_desc)], "Task Force Arrowhead Radio", false, false] call CBA_Settings_fnc_init;
["TFAR_showTransmittingHint", "CHECKBOX", [ELSTRING(settings,radio_showTransmittingHint),ELSTRING(settings,radio_showTransmittingHint_desc)], "Task Force Arrowhead Radio", true, false] call CBA_Settings_fnc_init;
["TFAR_showChannelChangedHint", "CHECKBOX", [ELSTRING(settings,radio_showChannelChangedHint),ELSTRING(settings,radio_showChannelChangedHint_desc)], "Task Force Arrowhead Radio", true, false] call CBA_Settings_fnc_init;


//Global variables
VARIABLE_DEFAULT(tf_west_radio_code,"_bluefor");//Server needs Radio codes for static_radios
VARIABLE_DEFAULT(tf_east_radio_code,"_opfor");

if (isNil "tf_independent_radio_code") then {
    tf_independent_radio_code = "_independent";

    if (([west, resistance] call BIS_fnc_areFriendly) and {!([east, resistance] call BIS_fnc_areFriendly)}) then {
        tf_independent_radio_code = "_bluefor";
    };

    if (([east, resistance] call BIS_fnc_areFriendly) and {!([west, resistance] call BIS_fnc_areFriendly)}) then {
        tf_independent_radio_code = "_opfor";
    };
};

GVAR(VehicleConfigCacheNamespace) = false call CBA_fnc_createNamespace;
GVAR(WeaponConfigCacheNamespace) = false call CBA_fnc_createNamespace;

if (hasInterface) then {//Clientside Variables
    call TFAR_fnc_initKeybinds;
    //PreInit variablesy
    VARIABLE_DEFAULT(tf_radio_channel_name,"TaskForceRadio");
    VARIABLE_DEFAULT(tf_radio_channel_password,"123");

    VARIABLE_DEFAULT(TFAR_DefaultRadio_Backpack_West,"TFAR_rt1523g");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Backpack_East,"TFAR_mr3000");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Backpack_Independent,"TFAR_anprc155");

    VARIABLE_DEFAULT(TFAR_DefaultRadio_Personal_West,"TFAR_anprc152");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Personal_East,"TFAR_fadak");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Personal_Independent,"TFAR_anprc148jem");

    VARIABLE_DEFAULT(TFAR_DefaultRadio_Rifleman_West,"TFAR_rf7800str");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Rifleman_East,"TFAR_pnr1000a");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Rifleman_Independent,"TFAR_anprc154");

    VARIABLE_DEFAULT(TFAR_DefaultRadio_Airborne_West,"TFAR_anarc210");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Airborne_East,"TFAR_mr6000l");
    VARIABLE_DEFAULT(TFAR_DefaultRadio_Airborne_Independent,"TFAR_anarc164");

    //#depreacted
    VARIABLE_DEFAULT(TF_defaultWestBackpack,"TFAR_rt1523g");
    VARIABLE_DEFAULT(TF_defaultEastBackpack,"TFAR_mr3000");
    VARIABLE_DEFAULT(TF_defaultGuerBackpack,"TFAR_anprc155");

    VARIABLE_DEFAULT(TF_defaultWestPersonalRadio,"TFAR_anprc152");
    VARIABLE_DEFAULT(TF_defaultEastPersonalRadio,"TFAR_fadak");
    VARIABLE_DEFAULT(TF_defaultGuerPersonalRadio,"TFAR_anprc148jem");

    VARIABLE_DEFAULT(TF_defaultWestRiflemanRadio,"TFAR_rf7800str");
    VARIABLE_DEFAULT(TF_defaultEastRiflemanRadio,"TFAR_pnr1000a");
    VARIABLE_DEFAULT(TF_defaultGuerRiflemanRadio,"TFAR_anprc154");

    VARIABLE_DEFAULT(TF_defaultWestAirborneRadio,"TFAR_anarc210");
    VARIABLE_DEFAULT(TF_defaultEastAirborneRadio,"TFAR_mr6000l");
    VARIABLE_DEFAULT(TF_defaultGuerAirborneRadio,"TFAR_anarc164");


    VARIABLE_DEFAULT(TF_terrain_interception_coefficient,7.0);

    MUTEX_INIT(TF_radio_request_mutex);

    TF_use_saved_sw_setting = false;
    TF_saved_active_sw_settings = nil;

    TF_use_saved_lr_setting = false;
    TF_saved_active_lr_settings = nil;

    TF_curator_backpack_1 = nil;
    TF_curator_backpack_2 = nil;
    TF_curator_backpack_3 = nil;

    TF_MAX_SW_VOLUME = 10;
    TF_MAX_LR_VOLUME = 10;

    TF_UNDERWATER_RADIO_DEPTH = -3;//Depth at which LR Radio will still work. Also underwater vehicle LR Radios

    TF_new_line = toString [0xA];
    TF_vertical_tab = toString [0xB];

    TF_last_lr_tangent_press = 0.0;

    TF_HintFnc = nil;

    TF_tangent_sw_pressed = false;
    TF_tangent_lr_pressed = false;

    TF_speakerDistance = 20;
    TF_speak_volume_level = "normal";
    TF_speak_volume_meters = TFAR_VOLUME_NORMAL;
    TF_min_voice_volume = TFAR_VOLUME_WHISPERING;
    TF_max_voice_volume = TFAR_VOLUME_YELLING;
    TF_sw_dialog_radio = nil;

    TF_last_speak_volume_level = TF_speak_volume_level;
    TF_last_speak_volume_meters = TF_speak_volume_meters;

    tf_lr_dialog_radio = nil;
    TF_lr_active_radio = nil;
    TF_lr_active_curator_radio = nil;


    TFAR_speakerRadios = [];
    TFAR_currentNearPlayers = [];
    TFAR_currentFarPlayers = [];
    TFAR_currentNearPlayersProcessing = [];
    TFAR_currentFarPlayersProcessing = [];

    TFAR_currentNearPlayersProcessed = true;
    TFAR_currentFarPlayersProcessed = true;
    TFAR_lastPlayerScanTime = 0;
    TFAR_volumeIndicatorFlashIndex = 0; //Increments everytime the volumeIndicator is shown when it's set to hidden. Makes sure the Hide function is only called once for the latest show


    tf_lastError = false;

    GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveSWRadio_lastCache",-1];
    GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveDDRadio_lastCache",-1];

    GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_radiosList_lastCache",-1];
    GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_sendSpeakerRadioslastExec",-1];
    GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_requestRadios_lastExec",-1];
    GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_sendFrequencyInfo_lastExec",-1];
    GVAR(VehicleConfigCacheNamespace) setVariable ["lastRadioSettingUpdate",-1];

    ISNILS(TFAR_takingRadio,2);

    TFAR_lastLoadoutChange = 0;
};

if (!isMultiplayer && !is3DENMultiplayer) exitWith {}; //Don't do anything more in Singleplayer - down here to atleast have Hotkeys available before

if (isServer) then {//Serverside variables
    missionNamespace setVariable ["TF_server_addon_version",TFAR_ADDON_VERSION,true];
    TFAR_RadioCountHash = [] call CBA_fnc_hashCreate;
    TFAR_RadioSettingsNamespace = true call CBA_fnc_createNamespace;
    publicVariable "TFAR_RadioSettingsNamespace";
}
