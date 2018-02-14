#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSwChannel

  Author: NKey
    Gets the channel for the passed radio

  Arguments:
    Radio classname <STRING>

  Return Value:
    Channel <NUMBER>

  Example:
    _channel = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwChannel;

  Public: Yes
 */
params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [ACTIVE_CHANNEL_OFFSET, 0]
