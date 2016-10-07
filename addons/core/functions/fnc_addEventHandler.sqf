#include "script_component.hpp"

/*
    Name: TFAR_fnc_addEventHandler

    Author(s):
        L-H

    Description:
        Adds an eventhandler to the passed unit unless the unit is null then fires globally.

    Parameters:
        0: STRING - ID for custom handler
        1: STRING - ID for event
        2: CODE - Code to execute when event is fired.
        3: OBJECT - Unit to add the event to, ObjNull to add globally.

    Returns:
        NOTHING

    Example:
        ["MyID", "OnSpeak", {
            _unit = _this select 0;
            _volume = _this select 1;
            hint format ["%1 is speaking %2", name _unit, _volume];
        }, player] call TFAR_fnc_addEventHandler;
*/
private ["_handlers", "_alreadySet"];

params ["_customID", "_eventID", "_code", "_unit"];

if (isNull _unit) then {
    _unit = missionNamespace;
};
_eventID = format ["TFAR_event_%1", _eventID];
_handlers = _unit getVariable [_eventID, []];
_alreadySet = -1;
{
    if (_customID == (_x select 0)) exitWith {
        _alreadySet = _foreachIndex;
        _x set [1, _code];
    };
} foreach _handlers;
if (_alreadySet == -1) then {
    _handlers pushBack [_customID, _code];
};

_unit setVariable [_eventID, _handlers];
