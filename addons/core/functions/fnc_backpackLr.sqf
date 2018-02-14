#include "script_component.hpp"

/*
  Name: TFAR_fnc_backpackLr

  Author: NKey
    Returns the backpack radio (if there is one)

  Arguments:
    0: Unit <OBJECT>

  Return Value:
    Manpack or nil if no radio <ARRAY>

  Example:
    _radio = player call TFAR_fnc_backpackLR;

  Public: Yes
 */

private _backpack = backpack _this;
if (([_backpack, "tf_hasLRradio", 0] call TFAR_fnc_getVehicleConfigProperty) == 1) exitWith {
    [unitBackpack _this, "radio_settings"]
};
nil
