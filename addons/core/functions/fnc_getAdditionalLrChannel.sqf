#include "script_component.hpp"

/*
  Name: TFAR_fnc_getAdditionalLrChannel

  Author: NKey
    Gets the additional channel for the passed radio

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    Channel <NUMBER>

  Example:
    _channel = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getAdditionalLrChannel;

  Public: Yes
 */

(_this call TFAR_fnc_getLrSettings) param [TFAR_ADDITIONAL_CHANNEL_OFFSET,-1]
