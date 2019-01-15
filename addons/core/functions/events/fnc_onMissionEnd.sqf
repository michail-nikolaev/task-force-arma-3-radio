#include "script_component.hpp"

/*
  Name: TFAR_fnc_onMissionEnd

  Author: Dedmen
    Tells the Teamspeak plugin that we are not ingame anymore

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_onMissionEnd;

  Public: Yes
*/

"task_force_radio_pipe" callExtension "MISSIONEND~";

player call TFAR_fnc_releaseAllTangents;