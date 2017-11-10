#include "script_component.hpp"

/*
    Name: TFAR_fnc_backpackLR

    Author(s):
        NKey

    Description:
        Returns the backpack radio (if there is one)

    Parameters:
        0: Object: Unit

    Returns:
        ARRAY: Manpack or nil if no radio

    Example:
        _radio = player call TFAR_fnc_backpackLR;
*/

private _backpack = backpack _this;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getVehicleConfigProperty) == 1) exitWith {
    [unitBackpack _this, "radio_settings"]
};
nil
