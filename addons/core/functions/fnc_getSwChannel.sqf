#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwChannel

    Author(s):
        NKey

    Description:
        Gets the channel for the passed radio

    Parameters:
        STRING: Radio classname

    Returns:
        NUMBER: Channel

    Example:
        _channel = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwChannel;
*/

(_this call TFAR_fnc_getSwSettings) param [ACTIVE_CHANNEL_OFFSET,0]
