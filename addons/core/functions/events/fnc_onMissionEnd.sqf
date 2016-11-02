#include "script_component.hpp"

/*
    Name: TFAR_fnc_onMissionEnd

    Author(s):
        Dedmen

    Description:
        Tells the Teamspeak plugin that we are not ingame anymore

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_onMissionEnd;
*/

"task_force_radio_pipe" callExtension "MISSIONEND~"
