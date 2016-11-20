#include "script_component.hpp"

/*
    Name: TFAR_fnc_VehicleLR

    Author(s):
        NKey

    Description:
        Gets the LR radio of the vehicle and the settings for it depending on the player's
        position within the vehicle

    Parameters:
        0: Object - unit

    Returns:
        ARRAY: 0 - Object - Vehicle, 1 - String - Radio Settings ID

    Example:
        _radio = player call TFAR_fnc_VehicleLR;
*/
params ["_unit"];

if (isNull (objectParent _unit)) exitWith {[]};//Unit is not in vehicle

private _result = [];

switch (_unit) do {
    case (gunner (vehicle _unit)): {
        _result = [vehicle _unit, "gunner_radio_settings"];
    };
    case (driver (vehicle _unit)): {
        _result = [vehicle _unit, "driver_radio_settings"];
    };
    case (commander (vehicle _unit)): {
        _result = [vehicle _unit, "commander_radio_settings"];
    };
    case ((vehicle _unit) call TFAR_fnc_getCopilot): {
        _result = [vehicle _unit, "turretUnit_0_radio_setting"];
    };
};
_result
