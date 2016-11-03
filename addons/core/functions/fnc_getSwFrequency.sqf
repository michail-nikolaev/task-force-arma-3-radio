#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwFrequency

    Author(s):
        NKey
        L-H

    Description:
        Gets the frequency for the active channel.

    Parameters:
        STRING: Radio classname

    Returns:
        NUMBER: Frequency

    Example:
        _frequency = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwFrequency;
*/
params[["_radio","",[""]]];

[_radio, ((_radio call TFAR_fnc_getSwSettings) param [ACTIVE_CHANNEL_OFFSET,0])+1] call TFAR_fnc_getChannelFrequency;
