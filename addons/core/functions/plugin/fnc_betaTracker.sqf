#include "script_component.hpp"

/*
    Name: TFAR_fnc_betaTracker

    Author(s):
         Dedmen

    Description:
        Collects some statistic information to help make TFAR-beta better.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        [1,"test",test] call TFAR_fnc_betaTracker
*/

private _variables = [
                        [1, "playableUnits"             ,count playableUnits],
                        [2, "allUnits"                  ,count allUnits],
                        [3, "allPlayers"                  ,count allPlayers],
                        [4, "BIS_fnc_listCuratorPlayers",count (call BIS_fnc_listCuratorPlayers)],
                        [5, "isServer"                  ,isServer],
                        [6, "isDedicated"               ,isDedicated],
                        [7, "currentSW"                 ,count (TFAR_currentUnit call TFAR_fnc_radiosList)],
                        [8,"currentLR"                 ,count (TFAR_currentUnit call TFAR_fnc_lrRadiosList)],
                        [9,"nearPlayers"               ,count TFAR_currentNearPlayers],
                        [10,"farPlayers"                ,count TFAR_currentFarPlayers],
                        [11,"typeof"                    ,typeof TFAR_currentUnit],
                        [12,"diag_fps"                  ,round diag_fps],
                        [13,"diag_fpsmin"               ,round diag_fpsmin],
                        [14,"version"                   ,TFAR_ADDON_VERSION],
                        [15,"folder",                   ,configSourceMod (configFile >> "CfgPatches" >> "TFAR_core")]
                    ];
if (_this isEqualType []) then {
    _variables = _variables + _this;
};

private _request = format['TRACK	%1	%2	%3~',"beta",getPlayerUID player,_variables];

"task_force_radio_pipe" callExtension _request;
