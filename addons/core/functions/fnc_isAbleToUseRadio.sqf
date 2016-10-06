#include "script_component.hpp"

/*
    Name: TFAR_fnc_isAbleToUseRadio
    
    Author(s):

    Description:
        Checks whether the current unit is able to use their radio.
    
    Parameters:
    
    Returns:
        BOOLEAN
    
    Example:
        _ableToUseRadio = call TFAR_fnc_isAbleToUseRadio;
*/
!(TFAR_currentUnit getVariable ["tf_unable_to_use_radio", false])