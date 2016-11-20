#include "script_component.hpp"

/*
    Name: TFAR_fnc_removeEventHandler

    Author(s):
        L-H, Dedmen

    Description:
        Removes an EventHandler

    Parameters:
        0: STRING - ID for custom handler
        1: STRING - ID for event
    Returns:
        NOTHING

    Example:
        ["MyID", "OnSpeak"] call TFAR_fnc_removeEventHandler;
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
