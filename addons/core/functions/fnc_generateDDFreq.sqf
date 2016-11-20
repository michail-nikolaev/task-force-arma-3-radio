#include "script_component.hpp"

/*
    Name: TFAR_fnc_generateDDFreq

    Author(s):
        NKey

    Description:
        Generate diver radio freq.

    Parameters:
        NOTHING

    Returns:
        NOTHING

    Example:
        call TFAR_fnc_generateDDFreq;
*/

str (round (((random (TFAR_MAX_DD_FREQ - TFAR_MIN_DD_FREQ)) + TFAR_MIN_DD_FREQ) * TFAR_FREQ_ROUND_POWER) / TFAR_FREQ_ROUND_POWER)
