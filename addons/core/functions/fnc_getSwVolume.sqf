#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwVolume

    Author(s):
        NKey

    Description:
        Gets the volume of the passed radio

    Parameters:
        STRING: Radio classname

    Returns:
        NUMBER: Volume : range (0,10)

    Example:
        _volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;
*/
params[["_radio","",[""]]];

(_radio call TFAR_fnc_getSwSettings) param [VOLUME_OFFSET,false]
