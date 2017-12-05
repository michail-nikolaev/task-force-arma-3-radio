#include "script_component.hpp"

/*
    Name: TFAR_fnc_releaseAllTangents

    Author(s):
        Dedmen

    Description:
        Stops all outgoing Radio transmissions

    Parameters:
        OBJECT: the player

    Returns:
        NOTHING

    Example:
        player call TFAR_fnc_releaseAllTangents;
*/

"task_force_radio_pipe" callExtension (format ["RELEASE_ALL_TANGENTS	%1~", name _this]);//Async call will always return "OK"
