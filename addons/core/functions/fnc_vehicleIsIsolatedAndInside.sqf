#include "script_component.hpp"

/*
    Name: TFAR_fnc_vehicleIsIsolatedAndInside

    Author(s):
        NKey

    Description:
        Checks whether a unit is in an isolated vehicle and not turned out.

    Parameters:
        0: OBJECT - The unit to check.

    Returns:
        BOOLEAN - True if isolated and not turned out, false if turned out or vehicle is not isolated.

    Example:
        _isolated = player call TFAR_fnc_vehicleIsIsolatedAndInside;
*/
params ["_unit"];

if (isNull (objectParent _unit)) exitWith {false};//Unit is not in vehicle

if ((vehicle _unit) call TFAR_fnc_isVehicleIsolated && {!([_this] call TFAR_fnc_isTurnedOut)}) exitWith {true};

false
