#include "script_component.hpp"

/*
    Name: TFAR_fnc_getAdditionalLrChannel

    Author(s):
        NKey

    Description:
        Gets the additional channel for the passed radio

    Parameters:
        Array: Radio
            0: OBJECT - Radio object
            1: STRING - Radio ID

    Returns:
        NUMBER: Channel

    Example:
        _channel = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getAdditionalLrChannel;
*/

(_this call TFAR_fnc_getLrSettings) param [TFAR_ADDITIONAL_CHANNEL_OFFSET,-1]
