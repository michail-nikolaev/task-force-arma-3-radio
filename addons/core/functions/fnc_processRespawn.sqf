#include "script_component.hpp"

/*
    Name: TFAR_fnc_processRespawn

    Author(s):
        NKey
        L-H

    Description:
        Handles getting switching radios, handles whether a manpack must be added to the player or not.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_processRespawn;
*/
[{!(isNull player)},{
    TFAR_currentUnit = call TFAR_fnc_currentUnit;
    TFAR_currentUnit remoteExec ["TFAR_fnc_processRadiosServer", 2];
    TF_respawnedAt = time;
    [TFAR_currentUnit, false] call TFAR_fnc_forceSpectator;
    if (TFAR_ShowVolumeHUD) then { //#TODO should really move this into a macro
        (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];
    };
    call TFAR_fnc_updateSpeakVolumeUI;
}] call CBA_fnc_waitUntilAndExecute;
