#include "script_component.hpp"

/*
 * Name: TFAR_fnc_removeEventHandler
 *
 * Author: L-H, Dedmen
 * removes an eventhandler
 *
 * Arguments:
 * 0: custom event ID <STRING>
 * 1: event ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["MyID", "OnSpeak"] call TFAR_fnc_removeEventHandler;
 *
 * Public: Yes
 */

params ["_customID", "_eventName"];

private _handlersHash = missionNamespace getVariable format["tfar_EHandlers_%1",_eventName];
if (isNil "_handlersHash") exitWith {WARNING("Tried to delete non-existent Eventhandler");};

{
    [format ["TFAR_event_%1", _eventName], _x] call CBA_fnc_removeEventHandler;
} forEach ([_handlersHash,_customID] call CBA_fnc_hashGet);
[_handlersHash,_customID] call CBA_fnc_hashRem;
//We don't setVariable here because we are editing by ref.
//Could setVariable to nil of we just removed the last Handler.
