#include "script_component.hpp"

/*
    Name: TFAR_fnc_getLrChannel

    Author(s):
        NKey

    Description:
        Gets the channel for the passed radio

    Parameters:
        Array: Radio
            0: OBJECT - Radio object
            1: STRING - Radio ID

    Returns:
        NUMBER: Channel

    Example:
        _channel = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrChannel;
*/

(_this call TFAR_fnc_getLrSettings) param [ACTIVE_CHANNEL_OFFSET]
