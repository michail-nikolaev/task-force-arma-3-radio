#include "script_component.hpp"

/*
    Name: TFAR_fnc_getSwHalfDuplexOverride

    Author(s):
        MorpheusXAUT

    Description:
        Returns the passed SW radio's capabilities to use full-duplex mode although global half-duplex has been enabled.

    Parameters:
        0: STRING - Radio classname

    Returns:
        BOOLEAN - Half-duplex mode should be skipped for this SW radio

    Example:
        [call TFAR_fnc_activeSwRadio] call TFAR_fnc_getSwHalfDuplexOverride;
*/

params[["_radio","",[""]]];

(_radio call TFAR_fnc_getSwSettings) param [HALFDUPLEX_OVERRIDE_OFFSET,false]
