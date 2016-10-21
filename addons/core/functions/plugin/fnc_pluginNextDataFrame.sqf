#include "script_component.hpp"

/*
    Name: TFAR_fnc_pluginNextDataFrame

    Author(s):
        NKey

    Description:
        Tells the plugin that the current DataFrame is done.
        This tells the plugin that we are currently ingame.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_pluginNextDataFrame
*/

//Async call will always return "OK"
private _request = format["DFRAME~"];
_result = "task_force_radio_pipe" callExtension _request;
