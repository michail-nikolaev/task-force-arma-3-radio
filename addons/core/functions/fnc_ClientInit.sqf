#include "script_component.hpp"

disableSerialization;

#include "keys.sqf"

// Menus
#include "flexiUI\flexiInit.sqf"

#include "diary.sqf"

waitUntil {sleep 0.2;time > 0};
waitUntil {sleep 0.1;!(isNull player)};



//#API Variables
//#TODO rename radio code vars
//#TODO rename new vars
DEPRECATE_VARIABLE(tf_give_personal_radio_to_regular_soldier,tf_give_personal_radio_to_regular_soldier);
DEPRECATE_VARIABLE(tf_no_auto_long_range_radio,tf_no_auto_long_range_radio);
DEPRECATE_VARIABLE(tf_give_microdagr_to_soldier,tf_give_microdagr_to_soldier);

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



TFAR_currentUnit = call TFAR_fnc_currentUnit;
[parseText(localize ("STR_init")), 5] call TFAR_fnc_showHint;

// loadout cleaning on initialization to avoid duplicate radios ids in Arsenal
[] call TFAR_fnc_loadoutReplaceProcess;

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
TFAR_RadioReqLinkFirstItem = true;
TF_last_request_time = 0;
TF_respawnedAt = time;//first spawn so.. respawned now

[] spawn {
    waituntil {sleep 0.1;!(IsNull (findDisplay 46))};

    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
    (findDisplay 46) displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onSwTangentPressedHack"];
    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
    (findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];

    if (isMultiplayer) then {
        call TFAR_fnc_pluginNextDataFrame; //tell plugin that we are ingame
        [TFAR_fnc_processPlayerPositions,0.1 /*100 milliseconds*/] call CBA_fnc_addPerFrameHandler;
        [TFAR_fnc_sendFrequencyInfo,0.3 /*300 milliseconds*/] call CBA_fnc_addPerFrameHandler;
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

    if !(TFAR_currentUnit getVariable ["TFAR_HandlersSet",false]) then {
        TFAR_currentUnit addEventHandler ["Take", {
            private _class = configFile >> "CfgWeapons" >> (_this select 2);
            if (isClass _class AND {isNumber (_class >> "tf_radio")}) then {
                [(_this select 2), getPlayerUID player] call TFAR_fnc_setRadioOwner;
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

}] call CBA_fnc_addPlayerEventHandler;

//onArsenal PostClose event
[missionnamespace,"arsenalClosed", {
    "PostClose" call TFAR_fnc_onArsenal;
}] call bis_fnc_addScriptedEventhandler;

player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];

player addEventHandler ["killed", {
    TF_use_saved_sw_setting = true;
    TF_use_saved_lr_setting = true;
    TFAR_RadioReqLinkFirstItem = true;
    call TFAR_fnc_hideHint;
}];

call TFAR_fnc_processRespawn; //Handle our current spawn
[] spawn TFAR_fnc_radioReplaceProcess;//#TODO move to PFH


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


call TFAR_fnc_sendPluginConfig;
