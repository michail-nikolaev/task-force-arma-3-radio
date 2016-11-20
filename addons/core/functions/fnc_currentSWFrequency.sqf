#include "script_component.hpp"

/*
    Name: TFAR_fnc_currentLWFrequency

    Author(s):
        NKey

    Description:
        Returns current Frequency of the active SW Radio

    Parameters:

    Returns:
        0: STRING: Frequency of active SW Radio

    Example:
        _SWFrequency = call TFAR_fnc_currentSWFrequency
*/

(call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwFrequency
