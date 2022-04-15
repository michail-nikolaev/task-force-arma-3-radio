#include "script_component.hpp"

/*
  Name: TFAR_fnc_onSplendidCamera

  Author: Ampersand
    Eventhandler that fires when opening the Splendid Camera

  Arguments: - Passed from Extended_DisplayUnload_EventHandlers >> RscDisplayCamera
    0: Display <DISPLAY>
    1: Event Type <NUMBER>

  Return Value:
    None

  Example:
    [] call TFAR_fnc_onSplendidCamera;

  Public: No
*/
params [["_display",displayNull], ["_eventType","Open"]];

player call TFAR_fnc_releaseAllTangents; //Stop all radio transmissions

switch _eventType do {
    case "Open": {
        if (TFAR_splendidCamEars) then {
            player setVariable ["TF_fnc_position", {private _pctw = positionCameraToWorld [0,0,0]; [AGLToASL _pctw, (positionCameraToWorld [0,0,1]) vectorDiff _pctw]}];
        }
    };
    case 2: {
        if (TFAR_splendidCamEars) then {
            player setVariable ["TF_fnc_position", nil];
        }
    };
};
