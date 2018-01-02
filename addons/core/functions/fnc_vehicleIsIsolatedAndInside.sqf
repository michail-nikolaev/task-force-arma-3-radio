#include "script_component.hpp"

/*
 * Name: TFAR_fnc_vehicleIsIsolatedAndInside
 *
 * Author: NKey
 * Checks whether a unit is in an isolated vehicle and not turned out.
 *
 * Arguments:
 * 0: The unit to check. <OBJECT>
 *
 * Return Value:
 * True if isolated and not turned out, false if turned out or vehicle is not isolated. <BOOL>
 *
 * Example:
 * _isolated = player call TFAR_fnc_vehicleIsIsolatedAndInside;
 *
 * Public: Yes
 */
params ["_unit"];

if (isNull (objectParent _unit)) exitWith {false};//Unit is not in vehicle

if (!(isTurnedOut _unit) && {(vehicle _unit) call TFAR_fnc_isVehicleIsolated}) exitWith {true};

false
