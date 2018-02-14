#include "script_component.hpp"

/*
  Name: TFAR_fnc_getLrChannel

  Author: NKey
    Gets the channel for the passed radio

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    Channel <NUMBER>

  Example:
    _channel = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrChannel;

  Public: Yes
*/

(_this call TFAR_fnc_getLrSettings) param [ACTIVE_CHANNEL_OFFSET]
