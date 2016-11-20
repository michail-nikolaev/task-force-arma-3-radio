#include "script_component.hpp"

/*
    Name: TFAR_fnc_fireEventHandlers

    Author(s):
        L-H

    Description:
        Fires all eventhandlers associated with the passed unit

    Parameters:
        0: STRING - ID for event
        2: ANY - parameters

    Returns:
        NOTHING

    Example:
        ["OnSpeak", [player, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
*/

params ["_eventName", "_parameters"];

[format["TFAR_event_%1", _eventName],_parameters] call CBA_fnc_localEvent;
