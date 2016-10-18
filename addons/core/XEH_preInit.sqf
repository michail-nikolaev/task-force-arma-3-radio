#include "script_component.hpp"

#include "XEH_PREP.sqf"

// server
["TF_no_auto_long_range_radio", "CHECKBOX", localize "STR_radio_no_auto_long_range_radio", "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TF_give_personal_radio_to_regular_soldier", "CHECKBOX", localize "STR_radio_give_personal_radio_to_regular_soldier", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TF_give_microdagr_to_soldier", "CHECKBOX", localize "STR_radio_give_microdagr_to_soldier", "Task Force Arrowhead Radio", true, true] call CBA_Settings_fnc_init;
["TF_same_sw_frequencies_for_side", "CHECKBOX", localize "STR_radio_same_sw_frequencies_for_side", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TF_same_lr_frequencies_for_side", "CHECKBOX", localize "STR_radio_same_lr_frequencies_for_side", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
["TF_same_dd_frequencies_for_side", "CHECKBOX", localize "STR_radio_same_dd_frequencies_for_side", "Task Force Arrowhead Radio", false, true] call CBA_Settings_fnc_init;
// client
["TF_default_radioVolume", "SLIDER", localize "STR_radio_default_radioVolume", "Task Force Arrowhead Radio", [1, 9, 9, 0]] call CBA_Settings_fnc_init;
["TF_volumeModifier_forceSpeech", "CHECKBOX", "Activate directSpeech when pressing volume modifier.", "Task Force Arrowhead Radio", false] call CBA_Settings_fnc_init;//#Stringtable


if (hasInterface) then {
//PreInit variables
    if (isNil "tf_radio_channel_name") then {
        tf_radio_channel_name = "TaskForceRadio";
    };
    if (isNil "tf_radio_channel_password") then {
        tf_radio_channel_password = "123";
    };
    if (isNil "tf_west_radio_code") then {
        tf_west_radio_code = "_bluefor";
    };
    if (isNil "tf_east_radio_code") then {
        tf_east_radio_code = "_opfor";
    };
    if (isNil "tf_guer_radio_code") then {
        tf_guer_radio_code = "_independent";

        if (([west, resistance] call BIS_fnc_areFriendly) and {!([east, resistance] call BIS_fnc_areFriendly)}) then {
            tf_guer_radio_code = "_bluefor";
        };

        if (([east, resistance] call BIS_fnc_areFriendly) and {!([west, resistance] call BIS_fnc_areFriendly)}) then {
            tf_guer_radio_code = "_opfor";
        };
    };
    if (isNil "TF_defaultWestBackpack") then {
        TF_defaultWestBackpack = "TFAR_rt1523g";
    };
    if (isNil "TF_defaultEastBackpack") then {
        TF_defaultEastBackpack = "TFAR_mr3000";
    };
    if (isNil "TF_defaultGuerBackpack") then {
        TF_defaultGuerBackpack = "TFAR_anprc155";
    };

    if (isNil "TF_defaultWestPersonalRadio") then {
        TF_defaultWestPersonalRadio = "TFAR_anprc152";
    };
    if (isNil "TF_defaultEastPersonalRadio") then {
        TF_defaultEastPersonalRadio = "TFAR_fadak";
    };
    if (isNil "TF_defaultGuerPersonalRadio") then {
        TF_defaultGuerPersonalRadio = "TFAR_anprc148jem";
    };

    if (isNil "TF_defaultWestRiflemanRadio") then {
        TF_defaultWestRiflemanRadio = "TFAR_rf7800str";
    };
    if (isNil "TF_defaultEastRiflemanRadio") then {
        TF_defaultEastRiflemanRadio = "TFAR_pnr1000a";
    };
    if (isNil "TF_defaultGuerRiflemanRadio") then {
        TF_defaultGuerRiflemanRadio = "TFAR_anprc154";
    };

    if (isNil "TF_defaultWestAirborneRadio") then {
        TF_defaultWestAirborneRadio = "TFAR_anarc210";
    };
    if (isNil "TF_defaultEastAirborneRadio") then {
        TF_defaultEastAirborneRadio = "TFAR_mr6000l";
    };
    if (isNil "TF_defaultGuerAirborneRadio") then {
        TF_defaultGuerAirborneRadio = "TFAR_anarc164";
    };

    if (isNil "TF_terrain_interception_coefficient") then {
        TF_terrain_interception_coefficient = 7.0;
    };


    TF_radio_request_mutex = false;

    TF_use_saved_sw_setting = false;
    TF_saved_active_sw_settings = nil;

    TF_use_saved_lr_setting = false;
    TF_saved_active_lr_settings = nil;

    TF_curator_backpack_1 = nil;
    TF_curator_backpack_2 = nil;
    TF_curator_backpack_3 = nil;

    TF_MAX_SW_VOLUME = 10;
    TF_MAX_LR_VOLUME = 10;
    TF_MAX_DD_VOLUME = 10;

    TF_UNDERWATER_RADIO_DEPTH = -3;

    TF_new_line = toString [0xA];
    TF_vertical_tab = toString [0xB];

    TF_dd_volume_level = 7;

    TF_last_lr_tangent_press = 0.0;
    TF_last_dd_tangent_press = 0.0;

    TF_HintFnc = nil;

    TF_tangent_sw_pressed = false;
    TF_tangent_lr_pressed = false;
    TF_tangent_dd_pressed = false;

    TF_dd_frequency = nil;

    TF_speakerDistance = 20;
    TF_speak_volume_level = "normal";
    TF_speak_volume_meters = 20;
    TF_min_voice_volume = 5;
    TF_max_voice_volume = 60;
    TF_sw_dialog_radio = nil;

    TF_last_speak_volume_level = TF_speak_volume_level;
    TF_last_speak_volume_meters = TF_speak_volume_meters;

    tf_lr_dialog_radio = nil;
    TF_lr_active_radio = nil;
    TF_lr_active_curator_radio = nil;


    tf_msPerStep = 0;

    tf_speakerRadios = [];
    tf_nearPlayers = [];
    tf_farPlayers = [];

    tf_nearPlayersIndex = 0;
    tf_nearPlayersProcessed = true;

    tf_farPlayersIndex = 0;
    tf_farPlayersProcessed = true;

    tf_msNearPerStepMax = 0.025;
    tf_msNearPerStepMin = 0.1;
    tf_msNearPerStep = tf_msNearPerStepMax;
    tf_nearUpdateTime = 0.3;

    tf_msFarPerStepMax = 0.025;
    tf_msFarPerStepMin = 1.00;
    tf_msFarPerStep = tf_msFarPerStepMax;
    tf_farUpdateTime = 3.5;

    tf_lastFrequencyInfoTick = 0;
    tf_lastNearPlayersUpdate = 0;

    tf_lastError = false;

    tf_msSpectatorPerStepMax = 0.035;

    TFAR_previouscurrentUnit = nil;




};
