#include "script_component.hpp"

disableSerialization;

// Menus
#include "flexiUI\flexiInit.sqf"

#include "diary.sqf"

//#API Variables
DEPRECATE_VARIABLE(tf_give_personal_radio_to_regular_soldier,TFAR_givePersonalRadioToRegularSoldier);
DEPRECATE_VARIABLE(tf_no_auto_long_range_radio,TFAR_giveLongRangeRadioToGroupLeaders);
DEPRECATE_VARIABLE(tf_give_microdagr_to_soldier,TFAR_giveMicroDagrToSoldier);

DEPRECATE_VARIABLE(tf_defaultWestPersonalRadio,TFAR_DefaultRadio_Personal_West);
DEPRECATE_VARIABLE(tf_defaultEastPersonalRadio,TFAR_DefaultRadio_Personal_East);
DEPRECATE_VARIABLE(tf_defaultGuerPersonalRadio,TFAR_DefaultRadio_Personal_Independent);

DEPRECATE_VARIABLE(TF_defaultWestRiflemanRadio,TFAR_DefaultRadio_Rifleman_West);
DEPRECATE_VARIABLE(TF_defaultEastRiflemanRadio,TFAR_DefaultRadio_Rifleman_East);
DEPRECATE_VARIABLE(TF_defaultGuerRiflemanRadio,TFAR_DefaultRadio_Rifleman_Independent);

DEPRECATE_VARIABLE(TF_defaultWestAirborneRadio,TFAR_DefaultRadio_Airborne_West);
DEPRECATE_VARIABLE(TF_defaultEastAirborneRadio,TFAR_DefaultRadio_Airborne_East);
DEPRECATE_VARIABLE(TF_defaultGuerAirborneRadio,TFAR_DefaultRadio_Airborne_Independent);

DEPRECATE_VARIABLE(TF_defaultWestBackpack,TFAR_DefaultRadio_Backpack_West);
DEPRECATE_VARIABLE(TF_defaultEastBackpack,TFAR_DefaultRadio_Backpack_East);
DEPRECATE_VARIABLE(TF_defaultGuerBackpack,TFAR_DefaultRadio_Backpack_Independent);

DEPRECATE_VARIABLE(tf_radio_channel_name,TFAR_Teamspeak_Channel_Name);
DEPRECATE_VARIABLE(tf_radio_channel_password,TFAR_Teamspeak_Channel_Password);

TFAR_currentUnit = call TFAR_fnc_currentUnit;
[parseText(localize ("STR_init")), 5] call TFAR_fnc_showHint;

// loadout cleaning on initialization to avoid duplicate radios ids in Arsenal
[] spawn TFAR_fnc_loadoutReplaceProcess;//Yes we spawn this. Because it is time intensive and doesn't need to be finished before continuing

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
TFAR_RadioReqLinkFirstItem = true;//Radio Request Link first Item
TF_respawnedAt = time;//first spawn so.. respawned now

[   {!(isNull (findDisplay 46))},
    {
        (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
        (findDisplay 46) displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onTangentPressedHack"];
        (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];

        if (isMultiplayer) then {
            call TFAR_fnc_pluginNextDataFrame; //tell plugin that we are ingame
            if (isNil "INTERCEPT_TFAR") then {
                [PROFCONTEXT_NORTN(TFAR_fnc_processPlayerPositions), TFAR_PosUpdateMode] call CBA_fnc_addPerFrameHandler;
            } else {
                [compile "isNil {itfarprocP []}", TFAR_PosUpdateMode] call CBA_fnc_addPerFrameHandler;
            };
            [PROFCONTEXT_NORTN(TFAR_fnc_sendFrequencyInfo),0.3 /*300 milliseconds*/] call CBA_fnc_addPerFrameHandler;
            [PROFCONTEXT_NORTN(TFAR_fnc_sessionTracker),60 * 10/*10 minutes*/] call CBA_fnc_addPerFrameHandler;

            //Only want this to run after initial spawn was processed
            [
                {(time - TF_respawnedAt > 5)},
                {[PROFCONTEXT_NORTN(TFAR_fnc_radioReplaceProcess),2/*2 seconds*/] call CBA_fnc_addPerFrameHandler;}
            ] call CBA_fnc_waitUntilAndExecute;
        };
}] call CBA_fnc_waitUntilAndExecute;

if (player call TFAR_fnc_isForcedCurator) then {
    player unlinkItem "ItemRadio";
    player addVest "V_Rangemaster_belt";

    player enableSimulation false;//prevents falling sound when flying high in the sky
    player hideObject true;


    switch (typeOf (player)) do {
        case "B_VirtualCurator_F": {
                player addItem TFAR_DefaultRadio_Personal_West;
                TF_curator_backpack_1 = TFAR_DefaultRadio_Airborne_West createVehicleLocal [0, 0, 0];
            };
        case "O_VirtualCurator_F": {
                player addItem TFAR_DefaultRadio_Personal_East;
                TF_curator_backpack_1 = TFAR_DefaultRadio_Airborne_East createVehicleLocal [0, 0, 0];
            };
        case "I_VirtualCurator_F": {
                player addItem TFAR_DefaultRadio_Personal_Independent;
                TF_curator_backpack_1 = TFAR_DefaultRadio_Airborne_Independent createVehicleLocal [0, 0, 0];
            };
        default {
            player addItem TFAR_DefaultRadio_Personal_West;
            player addItem TFAR_DefaultRadio_Personal_East;
            player addItem TFAR_DefaultRadio_Personal_Independent;
            TF_curator_backpack_1 = TFAR_DefaultRadio_Airborne_West createVehicleLocal [0, 0, 0];
            TF_curator_backpack_2 = TFAR_DefaultRadio_Airborne_East createVehicleLocal [0, 0, 0];
            TF_curator_backpack_3 = TFAR_DefaultRadio_Airborne_Independent createVehicleLocal [0, 0, 0];
        };
    };
//Having Radios of different factions needs special handling
    ["CuratorFrequencyHandler", "newLRSettingsAssigned", {
        params ["_player","_radio"];
        private _settings = _radio call TFAR_fnc_getLrSettings;
        if (isNil "_settings") exitWith {};
        switch (_radio select 0) do {
            case TF_curator_backpack_1:{
                if (!isNil "TFAR_defaultFrequencies_lr_west") then {
                    _settings set [TFAR_FREQ_OFFSET,TFAR_defaultFrequencies_lr_west];
                };
            };
            case TF_curator_backpack_2:{
                if (!isNil "TFAR_defaultFrequencies_lr_east") then {
                    _settings set [TFAR_FREQ_OFFSET,TFAR_defaultFrequencies_lr_east];
                };
            };
            case TF_curator_backpack_3:{
                if (!isNil "TFAR_defaultFrequencies_lr_independent") then {
                    _settings set [TFAR_FREQ_OFFSET,TFAR_defaultFrequencies_lr_independent];
                };
            };
        };
        [_radio, _settings] call TFAR_fnc_setLrSettings;
    }, player] call TFAR_fnc_addEventHandler;


    ["CuratorFrequencyHandler", "OnRadiosReceived", {
        params ["_player","_radios"];
        {
            _radioClass = getText (configFile >> "CfgWeapons" >> _x >> "tf_parent");
            private _settings = _x call TFAR_fnc_getSwSettings;
            if (isNil "_settings") exitWith {};
            switch (toLower _radioClass) do {
                case (toLower TFAR_DefaultRadio_Personal_West):{
                    if (!isNil "TFAR_defaultFrequencies_sr_west") then {
                        _settings set [TFAR_FREQ_OFFSET,TFAR_defaultFrequencies_sr_west];
                    };
                };
                case (toLower TFAR_DefaultRadio_Personal_East):{
                    if (!isNil "TFAR_defaultFrequencies_sr_east") then {
                        _settings set [TFAR_FREQ_OFFSET,TFAR_defaultFrequencies_sr_east];
                    };
                };
                case (toLower TFAR_DefaultRadio_Personal_Independent):{
                    if (!isNil "TFAR_defaultFrequencies_sr_independent") then {
                        _settings set [TFAR_FREQ_OFFSET,TFAR_defaultFrequencies_sr_independent];
                    };
                };
            };
            [_x, _settings] call TFAR_fnc_setSwSettings;
            true
        } count _radios;
    }, player] call TFAR_fnc_addEventHandler;

};

//From ACEMOD
// "playerChanged" event
["unit", {
    //current unit changed (Curator took control of unit)

    if (player != (_this select 0)) then {
        player setVariable ["TFAR_controlledUnit",(_this select 0), true];//This tells other players that our position is different
    } else {
        player setVariable ["TFAR_controlledUnit",nil, true];
    };

    TFAR_currentUnit = (_this select 0);
    "task_force_radio_pipe" callExtension (format ["RELEASE_ALL_TANGENTS	%1~", name player]);//Async call will always return "OK"

    TFAR_lastLoadoutChange = diag_tickTime; //Switching unit also switches loadout
    TFAR_ConfigCacheNamespace setVariable ["lastRadioSettingUpdate",diag_tickTime]; //And changes Radios

    if !(TFAR_currentUnit getVariable ["TFAR_HandlersSet",false]) then {
        TFAR_currentUnit addEventHandler ["Take", {
            private _class = configFile >> "CfgWeapons" >> (_this select 2);
            if !(isClass _class) exitWith {};
            if (isNumber (_class >> "tf_radio")) exitWith {
                [(_this select 2), getPlayerUID player] call TFAR_fnc_setRadioOwner;
            };
            if (isNumber (_class >> "tf_prototype")) then {
                call TFAR_fnc_radioReplaceProcess;
            };
        }];
        TFAR_currentUnit addEventHandler ["Put", {
            private _class = configFile >> "CfgWeapons" >> (_this select 2);
            if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
                [(_this select 2), ""] call TFAR_fnc_setRadioOwner;
            };
        }];
        TFAR_currentUnit addEventHandler ["Killed", {
            params ["_unit"];
            private _items = (assignedItems _unit) + (items _unit);
            {
                _class = configFile >> "CfgWeapons" >> _x;
                if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
                    [_x, ""] call TFAR_fnc_setRadioOwner;
                };
                true;
            } count _items;
        }];
        TFAR_currentUnit setVariable ["TFAR_HandlersSet", true];
    };

},true] call CBA_fnc_addPlayerEventHandler;

["loadout", {
    //current units loadout changed.. Should invalidate any caches about players loadout.
    TFAR_lastLoadoutChange = diag_tickTime;
    TFAR_ConfigCacheNamespace setVariable ["lastRadioSettingUpdate",diag_tickTime];//Also updates Radio settings for safety
},true] call CBA_fnc_addPlayerEventHandler;




//onArsenal PostClose event
[missionnamespace,"arsenalClosed", {
    "PostClose" call TFAR_fnc_onArsenal;
}] call bis_fnc_addScriptedEventhandler;

player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];

player addEventHandler ["killed", {
    GVAR(use_saved_sr_setting) = true;
    GVAR(use_saved_lr_setting) = true;
    TFAR_RadioReqLinkFirstItem = true;
    call TFAR_fnc_hideHint;
}];

call TFAR_fnc_processRespawn; //Handle our current spawn


[   {!((isNil "TF_server_addon_version") and (time < 20))},
    {
        if (isNil "TF_server_addon_version") then {
            hintC (localize "STR_no_server");
        } else {
            if (TF_server_addon_version != TFAR_ADDON_VERSION) then {
                hintC format[localize "STR_different_version", TF_server_addon_version, TFAR_ADDON_VERSION];
            };
        };
}] call CBA_fnc_waitUntilAndExecute;

call TFAR_fnc_sendPluginConfig;
