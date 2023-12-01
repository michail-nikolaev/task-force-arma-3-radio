#include "script_component.hpp"

/*
  Name: TFAR_fnc_releaseAllTangents

  Author: Dedmen
    Stops all outgoing radio transmissions

  Arguments:
    the player <OBJECT>

  Return Value:
    None

  Example:
    player call TFAR_fnc_releaseAllTangents;

  Public: Yes
*/

params ["_unit"];

// Stops transmissions cleanly in-game (takes care of hint and in-game variables)
if (_unit isEqualTo TFAR_currentUnit) then {
    call TFAR_fnc_onSwTangentReleased;
    call TFAR_fnc_onAdditionalSwTangentReleased;
    call TFAR_fnc_onLRTangentReleased;
    call TFAR_fnc_onAdditionalLRTangentReleased;
};

"task_force_radio_pipe" callExtension (format ["RELEASE_ALL_TANGENTS	%1~", _unit getVariable ["TFAR_unitName", name _unit]]); //Async call will always return "OK"
