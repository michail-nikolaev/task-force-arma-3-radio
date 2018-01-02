#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setSwChannel
 *
 * Author: NKey
 * Sets the channel for the passed radio
 *
 * Arguments:
 * 0: Radio classname <STRING>
 * 1: Channel <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [call TFAR_fnc_activeSwRadio, 2] call TFAR_fnc_setSwChannel;
 *
 * Public: Yes
 */

params ["_radio_id", "_channel_to_set"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [ACTIVE_CHANNEL_OFFSET, _channel_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,		channel, additional
["OnSWchannelSet", [TFAR_currentUnit, _radio_id, _channel_to_set, false]] call TFAR_fnc_fireEventHandlers;
