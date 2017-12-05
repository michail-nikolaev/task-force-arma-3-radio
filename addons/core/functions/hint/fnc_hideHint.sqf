#include "script_component.hpp"

/*
    Name: TFAR_fnc_hideHint

    Author(s):
        L-H

    Description:
        Removes the hint from the bottom right

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_hideHint;
 */

("TFAR_HintLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
