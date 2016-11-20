#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwFrequency

    Author(s):
        NKey
        L-H

    Description:
        Sets the frequency for the currently active channel

    Parameters:
        0: STRING - Radio classname
        1: STRING - Frequency

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeSwRadio, "76.2"] call TFAR_fnc_setSwFrequency;
*/

params ["_radio", "_freq"];

[_radio, ((_radio call TFAR_fnc_getSwSettings) select ACTIVE_CHANNEL_OFFSET)+1, _freq] call TFAR_fnc_setChannelFrequency;
