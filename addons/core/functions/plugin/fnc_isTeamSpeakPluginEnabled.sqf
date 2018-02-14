#include "script_component.hpp"

/*
  Name: TFAR_fnc_isTeamSpeakPluginEnabled

  Author: NKey
    Returns is TeamSpeak plugin enabled on client.

  Arguments:
    None

  Return Value:
    is enabled <BOOL>

  Example:
    call TFAR_fnc_isTeamSpeakPluginEnabled;

  Public: Yes
*/

("task_force_radio_pipe" callExtension "TS_INFO	PING") == "PONG"
