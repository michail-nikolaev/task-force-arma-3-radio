#include "script_component.hpp"

/*
  Name: TFAR_ai_hearing_fnc_onSpeak
  
  Author: Dimitri Yuri, 2600K, Dedmen, Dorbedo
    notifies nearby AI's when player is Speaking
  
  Arguments:
    0: the unit <OBJECT>
    1: is speaking <BOOL>
  
  Return Value:
    None
  
  Example:
    [_unit, true] call TFAR_ai_hearing_fnc_onSpeak;
  
  Public: No
 */

params [["_unit", objNull, [objNull]], ["_isSpeaking", false, [true]]];

if ((!local _unit) || {!alive _unit} || {(vehicle _unit) call TFAR_fnc_isVehicleIsolated}) exitWith {};

[_unit, TF_speak_volume_meters] call FUNC(revealInArea);
