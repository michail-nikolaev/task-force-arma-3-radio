#include "script_component.hpp"

/*
    Name: TFAR_fnc_getLrHalfDuplexOverride

    Author(s):
        MorpheusXAUT

    Description:
        Returns the passed LR radio's capabilities to use full-duplex mode although global half-duplex has been enabled.

    Parameters:
        0: ARRAY - Radio
            0: OBJECT - Radio object
            1: STRING - Radio ID

    Returns:
        BOOLEAN - Half-duplex mode should be skipped for this SW radio

    Example:
        (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrHalfDuplexOverride;
*/

(_this call TFAR_fnc_getLrSettings) param [HALFDUPLEX_OVERRIDE_OFFSET]
