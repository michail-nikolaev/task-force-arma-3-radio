#include "script_component.hpp"

/*
  Name: TFAR_fnc_forceSpectator

  Author: NKey
    If second parameter is true player will moved to spectator mode
    If false - normal behaviour will be restored.
 
  Arguments:
    0: player <OBJECT>
    1: force <BOOL>

  Return Value:
    None

  Example:
    [player, true] call TFAR_fnc_forceSpectator;

  Public: Yes
 */

params ["_player", "_value"];

_player call TFAR_fnc_releaseAllTangents; //Stop all radio transmissions

_player setVariable ["TFAR_forceSpectator", _value, true];
_player setVariable ["TFAR_spectatorName", profileName, true];

if (TFAR_ShowVolumeHUD && _value) then { //Don't have a voice in spectator Mode so hide the HUD
    (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
