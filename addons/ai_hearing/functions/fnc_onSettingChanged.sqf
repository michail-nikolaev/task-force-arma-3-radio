#include "script_component.hpp"

/*
    Name: TFAR_ai_hearing_fnc_onSettingChanged

    Author(s):
        Dedmen

    Description:
        initializes/deinitializes the AI-Hearing
        This function should only be called via CBA_Settings

    Parameters:
        BOOL: enable the setting

    Returns:
        NOTHING

    Example:
        true call TFAR_ai_hearing_fnc_onSettingChanged;
*/

if !(hasInterface) exitWith {};
TRACE_1("AI Hearing Settings changed",TFAR_AICanHearPlayer);

switch (_thisSetting) do {
    case "TFAR_AICanHearPlayer": {
        if (_this) then {
            if !(isNil QGVAR(HandlerID_speak)) exitWith {};
            GVAR(HandlerID_receive) = ["TFAR_event_OnRadioReceive", FUNC(OnRadioReceive)] call CBA_fnc_addEventHandler;
        } else {
            if (isNil QGVAR(HandlerID_speak)) exitWith {};
            ["TFAR_event_OnSpeak", GVAR(HandlerID_speak)] call CBA_fnc_removeEventHandler;
            GVAR(HandlerID_speak) = nil;
        };
    };
    case "TFAR_AICanHearSpeaker": {
        if (_this) then {
            if !(isNil QGVAR(HandlerID_receive)) exitWith {};
            GVAR(HandlerID_receive) = ["TFAR_event_OnRadioReceive", FUNC(OnRadioReceive)] call CBA_fnc_addEventHandler;
        } else {
            if (isNil QGVAR(HandlerID_receive)) exitWith {};
            ["TFAR_event_OnRadioReceive", GVAR(HandlerID_receive)] call CBA_fnc_removeEventHandler;
            GVAR(HandlerID_speak) = nil;
        };
    };
};
