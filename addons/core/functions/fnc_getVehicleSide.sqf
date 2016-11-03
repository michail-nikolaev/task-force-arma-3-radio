#include "script_component.hpp"

/*
    Name: TFAR_fnc_getVehicleSide

    Author(s):
        NKey

    Description:
        Returns the side of the vehicle, based on the vehicle model and not who has captured it.
        Also takes into account a variable on the vehicle (tf_side)

    Parameters:
        OBJECT: vehicle

    Returns:
        SIDE: side of vehicle

    Example:
        _vehicleSide = (vehicle player) call TFAR_fnc_getVehicleSide;
*/
params [["_vehicle",objNull,[objNull]]];

private _side = _vehicle getVariable "tf_side";

if (isNil "_side") exitWith {[getNumber(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "side")] call BIS_fnc_sideType};

if (_side == "west") exitWith {west};
if (_side == "east") exitWith {east};

independent
