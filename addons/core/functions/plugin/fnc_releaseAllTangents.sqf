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

"task_force_radio_pipe" callExtension (format ["RELEASE_ALL_TANGENTS	%1~", name _this]);//Async call will always return "OK"
