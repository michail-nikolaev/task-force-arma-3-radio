#include "script_component.hpp"

<<<<<<< HEAD
/*
    Name: TFAR_fnc_isSpeaking
    
    Author(s):
        L-H

    Description:
        Check whether a unit is speaking
    
    Parameters:
        OBJECT - Unit
        
    Returns:
        BOOLEAN - If the unit is speaking
    
    Example:
        if (player call TFAR_fnc_isSpeaking) then {
            hint "You are speaking";
        };
*/
(("task_force_radio_pipe" callExtension format ["IS_SPEAKING	%1", name _this]) == "SPEAKING")
=======
/*
    Name: TFAR_fnc_isSpeaking
    
    Author(s):
        L-H

    Description:
        Check whether a unit is speaking
    
    Parameters:
        OBJECT - Unit
        
    Returns:
        BOOLEAN - If the unit is speaking
    
    Example:
        if (player call TFAR_fnc_isSpeaking) then {
            hint "You are speaking";
        };
*/
(("task_force_radio_pipe" callExtension format ["IS_SPEAKING	%1", name _this]) == "SPEAKING")
>>>>>>> 8b8749952bfc75733054c34ae530f0cfdbf1d5bb
