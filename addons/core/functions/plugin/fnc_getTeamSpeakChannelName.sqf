#include "script_component.hpp"

/*
  Name: TFAR_fnc_getTeamSpeakChannelName

  Author: NKey
    Returns TeamSpeak channel name.

  Arguments:
    None

  Return Value:
    name of the channel <STRING>

  Example:
    call TFAR_fnc_getTeamSpeakChannelName;

  Public: Yes
*/

"task_force_radio_pipe" callExtension "TS_INFO	CHANNEL"
