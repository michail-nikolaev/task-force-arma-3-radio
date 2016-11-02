#include "script_component.hpp"

/*
    Name: TFAR_fnc_currentDirection

    Author(s):
        NKey, Dedmen

    Description:
        Returns current direction of Units head.

    Parameters:
        0: UNIT: unit to get the Head direction from. (OPTIONAL)

    Returns:
        0: ARRAY: current look direction in Normalized 3D Vector

    Example:
        TFAR_currentUnit call TFAR_fnc_currentDirection
*/
params [["_unit",TFAR_currentUnit,[objNull]]];

getCameraViewDirection _unit
