#include "script_component.hpp"

/*
  Name: TFAR_fnc_getTeamspeakPluginVersion

  Author: Dedmen
    Returns TeamSpeak Plugin version.

  Arguments:
    None

  Return Value:
    version <STRING>

  Example:
    call TFAR_fnc_getTeamspeakPluginVersion;

  Public: Yes
 */

"task_force_radio_pipe" callExtension "TS_INFO	VERSION"
