#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_startExternalUsage

  Author: Dorbedo
    starts the external usage of a radio

  Arguments:
    0: target unit <OBJECT>
    1: player <OBJECT>
    2: the radio <ARRAY>

  Return Value:
    None

  Example:
    [_radio] call TFAR_core_fnc_startExternalUsage;

  Public: No
*/

params ["_target", "_unit", "_radio"];

TFAR_OverrideActiveLRRadio = _radio;
(_radio select 0) setVariable [QGVAR(usedExternallyBy), _unit, true];

_radio call TFAR_fnc_setActiveLrRadio;

TF_lr_dialog_radio = _radio;
call TFAR_fnc_onLrDialogOpen;
