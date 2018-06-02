#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_getTakeChildren

  Author: Dorbedo
    Used to provide an array of ace actions to be used as children actions in the interact menu.

  Arguments:
    0: the unit who loses the radio <OBJECT>
    1: the radio <ARRAY/STRING>

  Return Value:
    children ACE actions. <ARRAY>

  Example:
    _children = [_target, _player] call TFAR_core_fnc_getTakeChildren;

  Public: No
*/
params ["_target", "_radio"];

[
    [
        format["TFAR_takeRadio_%1",_radio],
        localize LSTRING(TAKE),
        "\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
        {call TFAR_fnc_takeRadio},
        {call TFAR_fnc_canTakeRadio},
        {},
        _radio
    ] call ACE_Interact_Menu_fnc_createAction,
    [],
    _target
]
