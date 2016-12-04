#include "script_component.hpp"

/*
    Name: TFAR_fnc_onCuratorInterfaceOpen

    Author(s):
        Dedmen

    Description:
        Eventhandler that fires when opening the Curator Interface

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_onCuratorInterfaceOpen;
*/
params [["_display",displayNull]];

_display displayAddEventHandler ["KeyDown", "[_this, 'keydown'] call TFAR_fnc_processCuratorKey"];
_display displayAddEventHandler ["KeyUp", "[_this, 'keyup'] call TFAR_fnc_processCuratorKey"];

_display displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onSwTangentReleasedHack"];
_display displayAddEventHandler ["keyDown", "_this call TFAR_fnc_onSwTangentPressedHack"];
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
