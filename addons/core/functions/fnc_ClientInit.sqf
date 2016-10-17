#include "script_component.hpp"


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

disableSerialization;

#include "keys.sqf"

// Menus
["TFAR","OpenSWRadioMenu",["Open SW Radio Menu","Open SW Radio Menu"],{["player",[],-3,"_this call TFAR_fnc_swRadioMenu",true] call cba_fnc_fleximenu_openMenuByDef;},{true},[TF_dialog_sw_scancode, TF_dialog_sw_modifiers],false] call cba_fnc_addKeybind;
["TFAR","OpenLRRadioMenu",["Open LR Radio Menu","Open LR Radio Menu"],{["player",[],-3,"_this call TFAR_fnc_lrRadioMenu",true] call cba_fnc_fleximenu_openMenuByDef;},{true},[TF_dialog_lr_scancode, TF_dialog_lr_modifiers],false] call cba_fnc_addKeybind;

["TFAR","DDRadioSettings",["DD Radio Settings","DD Radio Settings"],{call TFAR_fnc_onDDDialogOpen},{true},[TF_dialog_dd_scancode, TF_dialog_dd_modifiers],false] call cba_fnc_addKeybind;

["TFAR","SWChannel1",["SW Channel 1","SW Channel 1"],{[0] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_1_scancode, TF_sw_channel_1_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel2",["SW Channel 2","SW Channel 2"],{[1] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_2_scancode, TF_sw_channel_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel3",["SW Channel 3","SW Channel 3"],{[2] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_3_scancode, TF_sw_channel_3_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel4",["SW Channel 4","SW Channel 4"],{[3] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_4_scancode, TF_sw_channel_4_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel5",["SW Channel 5","SW Channel 5"],{[4] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_5_scancode, TF_sw_channel_5_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel6",["SW Channel 6","SW Channel 6"],{[5] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_6_scancode, TF_sw_channel_6_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel7",["SW Channel 7","SW Channel 7"],{[6] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_7_scancode, TF_sw_channel_7_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel8",["SW Channel 8","SW Channel 8"],{[7] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_8_scancode, TF_sw_channel_8_modifiers],false] call cba_fnc_addKeybind;


["TFAR","LRChannel1",["LR Channel 1","LR Channel 1"],{[0] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_1_scancode, TF_lr_channel_1_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel2",["LR Channel 2","LR Channel 2"],{[1] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_2_scancode, TF_lr_channel_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel3",["LR Channel 3","LR Channel 3"],{[2] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_3_scancode, TF_lr_channel_3_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel4",["LR Channel 4","LR Channel 4"],{[3] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_4_scancode, TF_lr_channel_4_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel5",["LR Channel 5","LR Channel 5"],{[4] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_5_scancode, TF_lr_channel_5_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel6",["LR Channel 6","LR Channel 6"],{[5] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_6_scancode, TF_lr_channel_6_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel7",["LR Channel 7","LR Channel 7"],{[6] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_7_scancode, TF_lr_channel_7_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel8",["LR Channel 8","LR Channel 8"],{[7] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_8_scancode, TF_lr_channel_8_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel9",["LR Channel 9","LR Channel 9"],{[8] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_9_scancode, TF_lr_channel_9_modifiers],false] call cba_fnc_addKeybind;


["TFAR","ChangeSpeakingVolume",["Change Speaking Volume","Change Speaking Volume"],{call TFAR_fnc_onSpeakVolumeChange},{true},[TF_speak_volume_scancode, TF_speak_volume_modifiers],false] call cba_fnc_addKeybind;

["TFAR", "YellingModifier", ["Yelling Modifier", "Yelling Modifier"], {["yelling"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_yelling_scancode, TF_speak_volume_modifier_yelling_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "WhisperingModifier", ["Whispering Modifier", "Whispering Modifier"], {["whispering"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_whispering_scancode, TF_speak_volume_modifier_whispering_modifiers], false] call cba_fnc_addKeybind;

["TFAR","CycleSWRadios",["Cycle >> SW Radios","Cycle >> SW Radios"],{true},{["next"] call TFAR_fnc_processSWCycleKeys},[TF_sw_cycle_next_scancode, TF_sw_cycle_next_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleSWRadios",["Cycle << SW Radios","Cycle << SW Radios"],{true},{["prev"] call TFAR_fnc_processSWCycleKeys},[TF_sw_cycle_prev_scancode, TF_sw_cycle_prev_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleLRRadios",["Cycle >> LR Radios","Cycle >> LR Radios"],{true},{["next"] call TFAR_fnc_processLRCycleKeys},[TF_lr_cycle_next_scancode, TF_lr_cycle_next_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleLRRadios",["Cycle << LR Radios","Cycle << LR Radios"],{true},{["prev"] call TFAR_fnc_processLRCycleKeys},[TF_lr_cycle_prev_scancode, TF_lr_cycle_prev_modifiers],false] call cba_fnc_addKeybind;


["TFAR","SWStereoBoth",    ["SW Stereo: Both","SW Stereo: Both"],{[0] call TFAR_fnc_processSWStereoKeys},    {true},[TF_sw_stereo_both_scancode, TF_sw_stereo_both_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWStereoLeft",    ["SW Stereo: Left","SW Stereo: Left"],{[1] call TFAR_fnc_processSWStereoKeys},    {true},[TF_sw_stereo_left_scancode, TF_sw_stereo_left_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWStereoRight",["SW Stereo: Right","SW Stereo: Right"],{[2] call TFAR_fnc_processSWStereoKeys},{true},[TF_sw_stereo_right_scancode,TF_sw_stereo_right_modifiers],false] call cba_fnc_addKeybind;


["TFAR","LRStereoBoth",    ["LR Stereo: Both","LR Stereo: Both"],{[0] call TFAR_fnc_processLRStereoKeys},    {true},[TF_lr_stereo_both_scancode, TF_lr_stereo_both_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRStereoLeft",    ["LR Stereo: Left","LR Stereo: Left"],{[1] call TFAR_fnc_processLRStereoKeys},    {true},[TF_lr_stereo_left_scancode, TF_lr_stereo_left_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRStereoRight",    ["LR Stereo: Right","LR Stereo: Right"],{[2] call TFAR_fnc_processLRStereoKeys},{true},[TF_lr_stereo_right_scancode,TF_lr_stereo_right_modifiers],false] call cba_fnc_addKeybind;


["TFAR","SWTransmit",["SW Transmit","SW Transmit"],{call TFAR_fnc_onSwTangentPressed},{call TFAR_fnc_onSwTangentReleased},[TF_tangent_sw_scancode, TF_tangent_sw_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWTransmitAlt",["SW Transmit Alt","SW Transmit Alt"],{call TFAR_fnc_onSwTangentPressed},{call TFAR_fnc_onSwTangentReleased},[TF_tangent_sw_2_scancode, TF_tangent_sw_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWTransmitAdditional",["SW Transmit Additional","SW Transmit Additional"],{call TFAR_fnc_onAdditionalSwTangentPressed},{call TFAR_fnc_onAdditionalSwTangentReleased},[TF_tangent_additional_sw_scancode, TF_tangent_additional_sw_modifiers],false] call cba_fnc_addKeybind;

["TFAR","LRTransmit",["LR Transmit","LR Transmit"],{call TFAR_fnc_onLRTangentPressed},{call TFAR_fnc_onLRTangentReleased},[TF_tangent_lr_scancode, TF_tangent_lr_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRTransmitAlt",["LR Transmit Alt","LR Transmit Alt"],{call TFAR_fnc_onLRTangentPressed},{call TFAR_fnc_onLRTangentReleased},[TF_tangent_lr_2_scancode, TF_tangent_lr_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRTransmitAdditional",["LR Transmit Additional","LR Transmit Additional"],{call TFAR_fnc_onAdditionalLRTangentPressed},{call TFAR_fnc_onAdditionalLRTangentReleased},[TF_tangent_additional_lr_scancode, TF_tangent_additional_lr_modifiers],false] call cba_fnc_addKeybind;

["TFAR","DDTransmit",["DD Transmit","DD Transmit"],{call TFAR_fnc_onDDTangentPressed},{call TFAR_fnc_onDDTangentReleased},[TF_tangent_dd_scancode, TF_tangent_dd_modifiers],false] call cba_fnc_addKeybind;
["TFAR","DDTransmitAlt",["DD Transmit Alt","DD Transmit Alt"],{call TFAR_fnc_onDDTangentPressed},{call TFAR_fnc_onDDTangentReleased},[TF_tangent_dd_2_scancode, TF_tangent_dd_2_modifiers],false] call cba_fnc_addKeybind;

#include "diary.sqf"

waitUntil {sleep 0.2;time > 0};
waitUntil {sleep 0.1;!(isNull player)};

TFAR_currentUnit = call TFAR_fnc_currentUnit;
[parseText(localize ("STR_init")), 5] call TFAR_fnc_ShowHint;

// loadout cleaning on initialization to avoid duplicate radios ids
[] call TFAR_fnc_loadoutReplaceProcess;

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

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
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

[] spawn {
    waituntil {sleep 0.1;!(IsNull (findDisplay 46))};

    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
    (findDisplay 46) displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onSwTangentPressedHack"];
    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];

    if (isMultiplayer) then {
        call TFAR_fnc_sendVersionInfo;
        [TFAR_fnc_processPlayerPositions] call CBA_fnc_addPerFrameHandler;
        [TFAR_fnc_sessionTracker,60 * 10/*10 minutes*/] call CBA_fnc_addPerFrameHandler;
    };
};

TF_first_radio_request = true;
TF_last_request_time = 0;

player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];
player addEventHandler ["killed", {
    TF_use_saved_sw_setting = true;
    TF_use_saved_lr_setting = true;
    TF_first_radio_request = true;
    call TFAR_fnc_HideHint;
}];

[] spawn {
    call TFAR_fnc_processRespawn;
};
TF_respawnedAt = time;
TFAR_previouscurrentUnit = nil;
[] spawn {
    waitUntil {sleep 0.1;!(isNull player)};
    if (player call TFAR_fnc_isForcedCurator) then {
        player enableSimulation false;
        player hideObject true;

        player unlinkItem "ItemRadio";
        player addVest "V_Rangemaster_belt";

        switch (typeOf (player)) do {
            case "B_VirtualCurator_F": {
                    player addItem TF_defaultWestPersonalRadio;
                    TF_curator_backpack_1 = TF_defaultWestAirborneRadio createVehicleLocal [0, 0, 0];
                };
            case "O_VirtualCurator_F": {
                    player addItem TF_defaultEastPersonalRadio;
                    TF_curator_backpack_1 = TF_defaultEastAirborneRadio createVehicleLocal [0, 0, 0];
                };
            case "I_VirtualCurator_F": {
                    player addItem TF_defaultGuerPersonalRadio;
                    TF_curator_backpack_1 = TF_defaultGuerAirborneRadio createVehicleLocal [0, 0, 0];
                };
            default {
                player addItem TF_defaultWestPersonalRadio;
                player addItem TF_defaultEastPersonalRadio;
                player addItem TF_defaultGuerPersonalRadio;
                TF_curator_backpack_1 = TF_defaultWestAirborneRadio createVehicleLocal [0, 0, 0];
                TF_curator_backpack_2 = TF_defaultEastAirborneRadio createVehicleLocal [0, 0, 0];
                TF_curator_backpack_3 = TF_defaultGuerAirborneRadio createVehicleLocal [0, 0, 0];
            };
        };

        [] spawn {
            while {true} do {
                if !(isNull curatorCamera) then {
                    player setPosATL (getPosATL curatorCamera);
                    player setDir (getDir curatorCamera);
                };
                sleep 1;
            };
        };
    };
    sleep 2;
    if (player in (call BIS_fnc_listCuratorPlayers)) then {
        [] spawn {
            while {true} do {
                waitUntil {sleep 0.1;!(isNull (findDisplay 312))};
                (findDisplay 312) displayAddEventHandler ["KeyDown", "[_this, 'keydown'] call TFAR_fnc_processCuratorKey"];
                (findDisplay 312) displayAddEventHandler ["KeyUp", "[_this, 'keyup'] call TFAR_fnc_processCuratorKey"];
                waitUntil {sleep 0.1;isNull (findDisplay 312)};
            };
        };
    };

    call TFAR_fnc_radioReplaceProcess;
};

[] spawn {
    waitUntil {sleep 0.1;!((isNil "TF_server_addon_version") and (time < 20))};
    if (isNil "TF_server_addon_version") then {
        hintC (localize "STR_no_server");
    } else {
        if (TF_server_addon_version != TFAR_ADDON_VERSION) then {
            hintC format[localize "STR_different_version", TF_server_addon_version, TFAR_ADDON_VERSION];
        };
    };
};

if (player in (call BIS_fnc_listCuratorPlayers)) then {
    [] spawn {
        while {true} do {
            waitUntil {sleep 0.1;!(isNull (findDisplay 312))};
            (findDisplay 312) displayAddEventHandler ["KeyDown", "[_this, 'keydown'] call TFAR_fnc_processCuratorKey"];
            (findDisplay 312) displayAddEventHandler ["KeyUp", "[_this, 'keyup'] call TFAR_fnc_processCuratorKey"];
            (findDisplay 312) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
            (findDisplay 312) displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onSwTangentPressedHack"];
            (findDisplay 312) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
            (findDisplay 312) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];
            waitUntil {sleep 0.1;isNull (findDisplay 312)};
        };
    };
};

//From ACEMOD
// "playerChanged" event
["unit", {
    //current unit changed (Curator took control of unit)
    if (TFAR_currentUnit != (_this select 0)) then {
        TFAR_currentUnit setVariable ["tf_controlled_unit",(_this select 0)];
    } else {
        TFAR_currentUnit setVariable ["tf_controlled_unit",nil];
    };
}] call CBA_fnc_addPlayerEventHandler;
diag_log "ClientInitAddHandler";
//onArsenal PostClose event
[missionnamespace,"arsenalClosed", {
diag_log "arsenalClosedHandler";
    "PostClose" call TFAR_fnc_onArsenal;
}] call bis_fnc_addScriptedEventhandler;
