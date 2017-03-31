#include "script_component.hpp"

/*
    Name: TFAR_fnc_onCuratorInterface

    Author(s):
        Dedmen

    Description:
        Eventhandler that fires when opening the Curator Interface

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_onCuratorInterface;
*/
params [["_display",displayNull],["_eventType","Close"]];

switch _eventType do {
    case "Open": {
        _display displayAddEventHandler ["KeyDown", "[_this, 'keydown'] call TFAR_fnc_processCuratorKey"];
        _display displayAddEventHandler ["KeyUp", "[_this, 'keyup'] call TFAR_fnc_processCuratorKey"];

        _display displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
        _display displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onTangentPressedHack"];
        _display displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];


        if (player call TFAR_fnc_isForcedCurator) then {
            //Add PFH that moves curatorLogic's position to camera position,
            //so we can hear players relative to camera
            [{
                params ["_args","_handle"];
                if !(isNull curatorCamera) then {
                    player setPosATL (getPosATL curatorCamera);
                    player setDir (getDir curatorCamera);
                } else {
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };
            },0.1] call CBA_fnc_addPerFrameHandler;//Don't need every frame.. every 100ms is enough
        };


        if (TFAR_ShowVolumeHUD) then {
            (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        };
        if (player getVariable ["TFAR_curatorCamEars",false]) then {
            player setVariable ["TF_fnc_position", {ATLToASL (positionCameraToWorld [0,0,0])}];
        }
    };
    case "Close": {
        if (TFAR_ShowVolumeHUD) then {
            (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];
        };
        call TFAR_fnc_updateSpeakVolumeUI;
        if (player getVariable ["TFAR_curatorCamEars",false]) then {
            player setVariable ["TF_fnc_position", nil];
        }
    };
};
