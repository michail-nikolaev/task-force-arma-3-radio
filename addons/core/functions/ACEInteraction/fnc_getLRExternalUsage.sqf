#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_getLRExternalUsage

  Author: Dorbedo
    returns the LR External Usage

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    Allowed to use externally <BOOL>

  Example:
    _return = _lrRadio call TFAR_core_fnc_getLRExternalUsage;

  Public: No
*/

(_this call TFAR_fnc_getLrSettings) param [TFAR_LR_ALLOWEXTERNALUSAGE, True, [false]]
