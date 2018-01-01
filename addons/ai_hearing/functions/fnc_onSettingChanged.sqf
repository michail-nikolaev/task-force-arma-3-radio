#include "script_component.hpp"

/*
 * Name: TFAR_ai_hearing_fnc_onSettingChanged
 *
 * Author: Dorbedo
 * initializes/deinitializes the AI-Hearing
 * This function should only be called via CBA_Settings
 *
 * Arguments:
 * 0: enable the setting <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * true call TFAR_ai_hearing_fnc_onSettingChanged;
 *
 * Public: yes
 */

if !(hasInterface) exitWith {};
TRACE_1("AI Hearing Settings changed",TFAR_AICanHearPlayer);
if (_this) then {
    if !(isNil QGVAR(HandlerID)) exitWith {};

    GVAR(HandlerID) = ["TFAR_event_OnSpeak", FUNC(onSpeak)] call CBA_fnc_addEventHandler;

} else {
    if (isNil QGVAR(HandlerID)) exitWith {};

    ["TFAR_event_OnSpeak", GVAR(HandlerID)] call CBA_fnc_removeEventHandler;
    GVAR(HandlerID) = nil;

};
