#include "script_component.hpp"

/*
    Name: TFAR_fnc_currentLRFrequency

    Author(s):
        NKey

    Description:
        Returns current Frequency of the active LR Radio

    Parameters:

    Returns:
        0: STRING: Frequency of active LR Radio

    Example:
        _LRFrequency = call TFAR_fnc_currentLRFrequency
*/

(call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrFrequency
