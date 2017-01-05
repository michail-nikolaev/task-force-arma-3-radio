#include "script_component.hpp"

/*
    Name: TFAR_fnc_setHeadsetLowered

    Author(s):
        Dedmen

    Description:
        Sets if the Headset is currently lowered

    Parameters:
        BOOL - Headset lowered

    Returns:
        NOTHING

    Example:
        true call TFAR_fnc_setHeadsetLowered;
 */
params [["_lowered",false,[false]] ];

//Using Plugin settngs framework because its easier to use for this. And doesn't cludder FREQ command
//Benchmarking this returned 0.024ms per call
["headsetLowered",_lowered] call TFAR_fnc_setPluginSetting;
