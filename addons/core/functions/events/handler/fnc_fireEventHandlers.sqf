#include "script_component.hpp"

/*
 * Name: TFAR_fnc_fireEventHandlers
 *
 * Author: L-H
 * Fires all eventhandlers associated with the passed unit
 *
 * Arguments:
 * 0: ID for event <STRING>
 * 1: parameters <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["OnSpeak", [player, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
 *
 * Public: Yes
 */

params ["_eventName", "_parameters"];

[format["TFAR_event_%1", _eventName],_parameters] call CBA_fnc_localEvent;
