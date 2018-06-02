#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_canUseExternal

  Author: Dorbedo
    can use the radio externally

  Arguments:
    0: the unit who gets the radio <OBJECT>
    1: the unit who loses the radio <OBJECT>
    2: the radio to be taken <STRING|ARRAY>

  Return Value:
    None

  Example:
    _return = [] call TFAR_core_fnc_canUseExternal;

  Public: Yes
*/

params ["_target", "_unit", "_radio"];
!(
    ((_radio isEqualType "") ||
    {(backpack _unit) isEqualTo ""}) ||
    {!(_radio call FUNC(canUseExternal))} ||
    {!(((_radio select 0) getVariable [QGVAR(usedExternallyBy), objNull]) isEqualTo objNull)}
)
