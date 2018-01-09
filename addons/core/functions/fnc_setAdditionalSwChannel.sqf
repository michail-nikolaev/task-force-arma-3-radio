#include "script_component.hpp"

/*
  Name: TFAR_fnc_setAdditionalSwChannel

  Author: NKey
    Sets the additional channel for the passed radio or disables it (if additional channel in arguments).

  Arguments:
    0: Radio classname <STRING>
    1: Channel <NUMBER>

  Return Value:
    None

  Example:
    [(call TFAR_fnc_activeSwRadio), 2] call TFAR_fnc_setAdditionalSwChannel;

  Public: Yes
 */

params ["_radio_id", "_channel_to_set"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
if ((_settings select TFAR_ADDITIONAL_CHANNEL_OFFSET) != _channel_to_set) then {
    _settings set [TFAR_ADDITIONAL_CHANNEL_OFFSET, _channel_to_set];
} else {
    _settings set [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1];
};
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,		channel, additional
["OnSWchannelSet", [TFAR_currentUnit, _radio_id, _channel_to_set, true]] call TFAR_fnc_fireEventHandlers;
