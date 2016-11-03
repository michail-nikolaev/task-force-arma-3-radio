#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwSpeakers

    Author(s):
        NKey

    Description:
        Gets the speakers setting of the passed radio

    Parameters:
        STRING: Radio classname

    Returns:
        BOOLEAN: speakers or headphones

    Example:
        _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwSpeakers;
*/
params[["_radio","",[""]]];

(_radio call TFAR_fnc_getSwSettings) param [TFAR_SW_SPEAKER_OFFSET,false]
