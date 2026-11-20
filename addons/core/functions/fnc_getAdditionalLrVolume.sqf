#include "script_component.hpp"

/*
  Name: TFAR_fnc_getAdditionalLrVolume

  Author: Darojax
    Gets the listening volume for the additional channel of an LR radio.
    Legacy settings without a separate value inherit the main channel volume.

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    Volume: range (0,10) <NUMBER>

  Example:
    _volume = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getAdditionalLrVolume;

  Public: Yes
*/

private _settings = _this call TFAR_fnc_getLrSettings;
_settings param [TFAR_ADDITIONAL_VOLUME_OFFSET, _settings param [VOLUME_OFFSET, 0]]
