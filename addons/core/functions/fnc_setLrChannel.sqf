#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setLrChannel
 *
 * Author: NKey
 * Sets the radio to the passed channel
 *
 * Arguments:
 * 0: LR Radio <ARRAY>
 * 1: Channel Range (0,8) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [call TFAR_fnc_activeLrRadio, 4] call TFAR_fnc_setLrChannel;
 *
 * Public: Yes
 */
params [["_radio", [], [[]], 2], ["_value", 0, [0]]];
_radio params ["_radio_object", "_radio_qualifier"];

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [ACTIVE_CHANNEL_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			channel, additional
["OnLRchannelSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, false]] call TFAR_fnc_fireEventHandlers;
