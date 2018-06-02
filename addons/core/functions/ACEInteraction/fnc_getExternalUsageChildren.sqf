#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_getExternalUsageChildren

  Author: Dorbedo
    Used to provide an array of ace actions to be used as children actions in the interact menu.

  Arguments:
    0: the unit who loses the radio <OBJECT>
    1: the radio <ARRAY/STRING>

  Return Value:
    children ACE actions. <ARRAY>

  Example:
    _children = [_target, _radio] call TFAR_core_fnc_getExternalUsageChildren;

  Public: No
*/
params ["_target", "_unit", "_radio"];

[
    [
        format["TFAR_useExternal_%1",_radio],
        localize LSTRING(useExternally),
        "",
        {call FUNC(startExternalUsage)},
        {call FUNC(canUseExternal)},
        {},
        _radio
    ] call ACE_Interact_Menu_fnc_createAction,
    [],
    _target
]
