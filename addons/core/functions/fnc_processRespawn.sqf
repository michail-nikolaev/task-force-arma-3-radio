#include "script_component.hpp"

/*
  Name: TFAR_fnc_processRespawn

  Author: NKey, Garth de Wet (L-H)
    Handles getting switching radios, handles whether a manpack must be added to the player or not.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_processRespawn;

  Public: No
 */

[{!(isNull player)}, {
    TFAR_currentUnit = call TFAR_fnc_currentUnit;

    TF_respawnedAt = time;
    if (alive TFAR_currentUnit) then {
        if (TFAR_giveMicroDagrToSoldier)  then {
            TFAR_currentUnit linkItem "TFAR_microdagr";
        };

        [
            {(time - TF_respawnedAt > 5)},
            {true call TFAR_fnc_requestRadios;}
        ] call CBA_fnc_waitUntilAndExecute;

        //Handle backpack replacement for group leaders
        if (leader TFAR_currentUnit != TFAR_currentUnit) exitWith {};
        if (!TFAR_giveLongRangeRadioToGroupLeaders or {backpack TFAR_currentUnit == "B_Parachute"} or {player call TFAR_fnc_isForcedCurator}) exitWith {};
        if ([(backpack TFAR_currentUnit), "tf_hasLRradio", 0] call TFAR_fnc_getVehicleConfigProperty == 1) exitWith {};

        private _items = backpackItems TFAR_currentUnit;
        private _backPack = unitBackpack TFAR_currentUnit;
        private _newItems = [];

        TFAR_currentUnit action ["putbag", TFAR_currentUnit];
        //In my tests in editor it took 0.89 seconds till the backpack is down
        [{backpack TFAR_currentUnit == ""},
        {
            TFAR_currentUnit addBackpack ((call TFAR_fnc_getDefaultRadioClasses) select 0);
            {
                if (TFAR_currentUnit canAddItemToBackpack _x) then {
                    TFAR_currentUnit addItemToBackpack _x;
                } else {
                    _newItems pushBack _x;
                };
                true;
            } count _items;

            clearItemCargoGlobal _backPack;
            clearMagazineCargoGlobal _backPack;
            clearWeaponCargoGlobal _backPack;
            {
                if (isClass (configFile >> "CfgMagazines" >> _x)) then{
                    _backPack addMagazineCargoGlobal [_x, 1];
                } else {
                    _backPack addItemCargoGlobal [_x, 1];
                    _backPack addWeaponCargoGlobal [_x, 1];
                };
                true;
            } count _newItems;
        }] call CBA_fnc_waitUntilAndExecute;
    };
    [TFAR_currentUnit, false] call TFAR_fnc_forceSpectator;
    if (TFAR_ShowVolumeHUD) then { //#TODO should really move this into a macro
        (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];
    };
    call TFAR_fnc_updateSpeakVolumeUI;
}] call CBA_fnc_waitUntilAndExecute;
