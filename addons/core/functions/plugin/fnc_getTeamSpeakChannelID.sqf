#include "script_component.hpp"

/*
  Name: TFAR_fnc_getTeamSpeakChannelID

  Author: NKey
    Returns TeamSpeak channel ID.

  Arguments:
    None

  Return Value:
    ID of the current channel <STRING>

  Example:
    call TFAR_fnc_getTeamSpeakChannelID;

  Public: Yes
*/

"task_force_radio_pipe" callExtension "TS_INFO	CHANNELID"
