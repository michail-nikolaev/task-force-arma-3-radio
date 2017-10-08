#include "script_component.hpp"

/*
    Name: TFAR_fnc_getTeamspeakPluginVersion

    Author(s):
        Dedmen

    Description:
        Returns TeamSpeak Plugin version.

    Parameters:
        Nothing

    Returns:
        STRING: version

    Example:
        call TFAR_fnc_getTeamspeakPluginVersion;
*/

"task_force_radio_pipe" callExtension "TS_INFO	VERSION"
