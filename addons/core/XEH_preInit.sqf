#include "script_component.hpp"

#include "XEH_PREP.sqf"

if (isServer && {isMultiplayer || is3DENMultiplayer}) then {
    ["CBA_settingsInitialized", DFUNC(serverInit)] call CBA_fnc_addEventhandler;
};
GVAR(SettingsInitialized) = false;
["CBA_settingsInitialized", {GVAR(SettingsInitialized) = true;}] call CBA_fnc_addEventhandler;

#include "CBA_Settings.sqf"

GVAR(VehicleConfigCacheNamespace) = false call CBA_fnc_createNamespace;
GVAR(WeaponConfigCacheNamespace) = false call CBA_fnc_createNamespace;

if (hasInterface) then {//Clientside Variables
    call TFAR_fnc_initKeybinds;
    //PreInit variablesy
    VARIABLE_DEFAULT(TFAR_radio_channel_name,"TaskForceRadio");
    VARIABLE_DEFAULT(TFAR_radio_channel_password,"123");

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

    VARIABLE_DEFAULT(TFAR_Teamspeak_Channel_Name,"TaskForceRadio");
    VARIABLE_DEFAULT(TFAR_Teamspeak_Channel_Password,"123");

    VARIABLE_DEFAULT(TF_terrain_interception_coefficient,7.0);

    MUTEX_INIT(TF_radio_request_mutex);

    GVAR(use_saved_sr_setting) = false;
    GVAR(saved_active_sr_settings) = nil;

    GVAR(use_saved_lr_setting) = false;
    GVAR(saved_active_lr_settings) = nil;

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
