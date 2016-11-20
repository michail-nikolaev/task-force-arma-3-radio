#include "script_component.hpp"

/*
    Name: TFAR_fnc_hasVehicleRadio

    Author(s):
        NKey

    Description:
        Checks _this for LW radio presence

    Parameters:
        OBJECT: Vehicle to check

    Returns:
        BOOL: True|False

    Example:
        _present = (vehicle player) call TFAR_fnc_hasVehicleRadio;
*/
params [["_vehicle",objNull,[objNull]]];

private _result = _vehicle getVariable "tf_hasRadio";
if (!isNil "_result") exitWith {_result};

([(typeof _vehicle), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1)
