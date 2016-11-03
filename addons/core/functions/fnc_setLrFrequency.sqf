#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrFrequency

    Author(s):
        NKey

    Description:
        Sets the frequency for the active channel

    Parameters:
        0: ARRAY - Radio
            0: OBJECT- Radio object
            1: STRING - Radio ID
        2: STRING - Frequency

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeLrRadio, "45.48"] call TFAR_fnc_setLrFrequency;
*/
params [["_radio",[],[[]],2], ["_frequency","",[""]]];

[_radio, ((_radio call TFAR_fnc_getLrSettings) select ACTIVE_CHANNEL_OFFSET)+1, _frequency] call TFAR_fnc_setChannelFrequency;
