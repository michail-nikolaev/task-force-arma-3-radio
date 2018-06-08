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

if (isNil "TFAR_OverrideActiveLRRadio") exitWith {};

TFAR_OverrideActiveLRRadio = nil;
(TFAR_OverrideActiveLRRadio select 0) setVariable [QGVAR(usedExternallyBy), objNull, true];
