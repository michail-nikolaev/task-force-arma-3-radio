#include "script_component.hpp"

/*
  Name: TFAR_fnc_getTeamSpeakServerUID

  Author: NKey
    Returns TeamSpeak server UID.

  Arguments:
    None

  Return Value:
    UID of the current server <STRING>

  Example:
    call TFAR_fnc_getTeamSpeakServerUID;

  Public: Yes
*/

"task_force_radio_pipe" callExtension "TS_INFO	SERVERUID"
