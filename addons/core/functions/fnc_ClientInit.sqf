#include "script_component.hpp"

disableSerialization;

#include "keys.sqf"

// Menus
["TFAR","OpenSWRadioMenu",["Open SW Radio Menu","Open SW Radio Menu"],{["player",[],-3,"_this call TFAR_fnc_swRadioMenu",true] call cba_fnc_fleximenu_openMenuByDef;},{true},[TF_dialog_sw_scancode, TF_dialog_sw_modifiers],false] call cba_fnc_addKeybind;
["TFAR","OpenLRRadioMenu",["Open LR Radio Menu","Open LR Radio Menu"],{["player",[],-3,"_this call TFAR_fnc_lrRadioMenu",true] call cba_fnc_fleximenu_openMenuByDef;},{true},[TF_dialog_lr_scancode, TF_dialog_lr_modifiers],false] call cba_fnc_addKeybind;

#include "diary.sqf"

waitUntil {sleep 0.2;time > 0};
waitUntil {sleep 0.1;!(isNull player)};

TFAR_currentUnit = call TFAR_fnc_currentUnit;
[parseText(localize ("STR_init")), 5] call TFAR_fnc_ShowHint;

// loadout cleaning on initialization to avoid duplicate radios ids in Arsenal
[] call TFAR_fnc_loadoutReplaceProcess;

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
TF_first_radio_request = true;
TF_last_request_time = 0;
TF_respawnedAt = time;//first spawn so.. respawned now

[] spawn {
    waituntil {sleep 0.1;!(IsNull (findDisplay 46))};

    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
    (findDisplay 46) displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onSwTangentPressedHack"];
    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];

    if (isMultiplayer) then {
        call TFAR_fnc_sendVersionInfo; //tell plugin that we are ingame and settings for serious-mode channel
        [TFAR_fnc_processPlayerPositions] call CBA_fnc_addPerFrameHandler;
        [TFAR_fnc_sessionTracker,60 * 10/*10 minutes*/] call CBA_fnc_addPerFrameHandler;
    };
};

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

//onArsenal PostClose event
[missionnamespace,"arsenalClosed", {
    "PostClose" call TFAR_fnc_onArsenal;
}] call bis_fnc_addScriptedEventhandler;

["full_duplex",TF_full_duplex] call TFAR_fnc_setPluginSettings;
player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];

player addEventHandler ["killed", {
    TF_use_saved_sw_setting = true;
    TF_use_saved_lr_setting = true;
    TF_first_radio_request = true;
    call TFAR_fnc_HideHint;
}];

call TFAR_fnc_processRespawn; //Handle our current spawn
call TFAR_fnc_radioReplaceProcess;


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
