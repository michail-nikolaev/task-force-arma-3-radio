#include "script_component.hpp"

/*
    Name: TFAR_fnc_isVehicleIsolated

    Author(s):
        NKey

    Description:
        Checks whether the vehicle is isolated.

    Parameters:
        OBJECT - The vehicle

    Returns:
        BOOLEAN

    Example:
        _isolated = (vehicle player) call TFAR_fnc_isVehicleIsolated;
*/
params ["_vehicle"];

private _isolated = [typeof _vehicle, "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty;

_isolated > 0.5
