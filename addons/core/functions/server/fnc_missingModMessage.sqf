#include "script_component.hpp"

/*
  Name: TFAR_fnc_missingModMessage

  Author: NKey, Garth de Wet (L-H), Dorbedo
    Returns a message on Clientside about missing TFAR

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_missingModMessage;

  Public: No
*/

if(isServer) exitWith {};
waitUntil {sleep 0.1;time > 3};
if !(isClass(configFile >> "CfgPatches" >> "tfar_core")) exitWith {
    [player, format["%1: LOOKS LIKE TASK FORCE RADIO ADDON IS NOT ENABLED OR VERSION LESS THAN 1.0", name player]] remoteExec ["globalChat", -2];
    if (isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam", objNull])) then {
        ["LOOKS LIKE TASK FORCE RADIO ADDON IS NOT ENABLED OR VERSION LESS THAN 1.0"] call BIS_fnc_guiMessage;
    };
};

if (getNumber (configFile >> "CfgPatches" >> "tfar_core" >> "server_api") != SERVER_API_VERSION) exitWith {
    [player, format["%1: TFAR API version doesn't match server", name player]] remoteExec ["globalChat", -2];
    if (isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam", objNull])) then {
        ["TFAR API version doesn't match server. You are running a different TFAR version than the server."] call BIS_fnc_guiMessage; 
    };
};

