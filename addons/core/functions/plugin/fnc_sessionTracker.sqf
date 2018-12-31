#include "script_component.hpp"

/*
  Name: TFAR_fnc_sessionTracker

  Author: NKey, Dedmen
    Collects some statistic information to help make TFAR great.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_sessionTracker;

  Public: No
*/

if (getClientStateNumber != 10) exitWith {}; //Prevents from firing on session lost or after disconnect

private _variables = [
                        [1, "group"                     ,count (units group player)],
                        [2, "playableUnits"             ,count playableUnits],
                        [3, "allUnits"                  ,count allUnits],
                        [4, "BIS_fnc_listCuratorPlayers",count (call BIS_fnc_listCuratorPlayers)],
                        [5, "faction"                   ,faction player],
                        [6, "isServer"                  ,isServer],
                        [7, "isDedicated"               ,isDedicated],
                        [8, "missionName"               ,missionName],
                        [9, "currentSW"                 ,count (TFAR_currentUnit call TFAR_fnc_radiosList)],
                        [10,"currentLR"                 ,count (TFAR_currentUnit call TFAR_fnc_lrRadiosList)],
                        [11,"nearPlayers"               ,count TFAR_currentNearPlayers],
                        [12,"farPlayers"                ,count TFAR_currentFarPlayers],
                        [13,"typeof"                    ,typeof TFAR_currentUnit],
                        [14,"diag_fps"                  ,round diag_fps],
                        [15,"diag_fpsmin"               ,round diag_fpsmin],
                        [16,"daytime"                   ,round daytime],
                        [17,"vehicle"                   ,typeof (vehicle TFAR_currentUnit)],
                        [18,"time"                      ,round time],
                        [19,"version"                   ,TFAR_ADDON_VERSION],
                        [20,"playerSide"                ,playerSide]
                    ];

private _request = format['TRACK	%1	%2	%3~',missionnamespace getVariable ["TFAR_sessionTrackerAction","start"],getPlayerUID player,_variables];

"task_force_radio_pipe" callExtension _request;
TFAR_sessionTrackerAction = "continue";
