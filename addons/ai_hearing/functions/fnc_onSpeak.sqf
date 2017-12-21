#include "script_component.hpp"

/*
    Author(s):
        By Dimitri Yuri edited by 2600K
        Dedmen, Dorbedo

    Description:
        notifies nearby AI's when player is Speaking
*/

params [["_unit", objNull, [objNull]], ["_isSpeaking", false, [true]]];

if ((!local _unit) || {!alive _unit} || {(vehicle _unit) call TFAR_fnc_isVehicleIsolated}) exitWith {};

[_unit, TF_speak_volume_meters] call FUNC(revealInArea);
