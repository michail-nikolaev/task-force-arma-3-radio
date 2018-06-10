#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_stopExternalUsage

  Author: Dorbedo
    stops the external usage of a radio

  Arguments:
    None

  Return Value:
    None

  Example:
    _return = [] call TFAR_core_fnc_stopExternalUsage;

  Public: No
*/

params [["_LRradio", TFAR_OverrideActiveLRRadio, [[]], [2]]];

If (TFAR_OverrideActiveLRRadio isEqualTo _LRradio) then {
    TFAR_OverrideActiveLRRadio = nil;
    (_LRradio select 0) setVariable [QGVAR(usedExternallyBy), objNull, true];
    [false, true] call DFUNC(stopExternalUsage);
} else {
    [QGVAR(stopExternalUsage), [_LRradio]] call CBA_fnc_targetEvent;
    (_LRradio select 0) setVariable [QGVAR(usedExternallyBy), objNull, true];
};
