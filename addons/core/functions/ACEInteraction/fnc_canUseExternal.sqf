#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_canUseExternal

  Author: Dorbedo
    can use the radio externally

  Arguments:
    0: the target unit <OBJECT>
    1: the player <OBJECT>
    2: the radio <ARRAY>

  Return Value:
    None

  Example:
    _return = [] call TFAR_core_fnc_canUseExternal;

  Public: No
*/

params ["_target", "_unit", ["_radio", [], [[]], [2]]];
!(
    (_radio isEqualTo []) ||
    {!(((_radio select 0) getVariable [QGVAR(usedExternallyBy), objNull]) isEqualTo objNull)} ||
    {(_unit distance (_radio select 0)) > TFAR_MAXREMOTELRRADIODISTANCE}
)
