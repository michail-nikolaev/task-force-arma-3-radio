#include "script_component.hpp"

/*
  Name: TFAR_fnc_getAdditionalSwChannel

  Author: NKey
    Gets the additional channel for the passed radio

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    Channel <NUMBER>

  Example:
    _channel = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getAdditionalSwChannel;

  Public: Yes
 */
params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [TFAR_ADDITIONAL_CHANNEL_OFFSET]
