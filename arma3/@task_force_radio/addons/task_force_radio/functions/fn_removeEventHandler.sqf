/*
 	Name: TFAR_fnc_removeEventHandler
 	
 	Author(s):
		L-H

 	Description:
		Removes an event from a unit/global
	
	Parameters:
		0: STRING - ID for custom handler
		1: STRING - ID for event
		2: OBJECT - Unit to add the event to, ObjNull to add globally.
 	
 	Returns:
		NOTHING
 	
 	Example:
		["MyID", "OnSpeak", player] call TFAR_fnc_removeEventHandler;
*/
private ["_customID", "_eventID", "_unit", "_handlers", "_alreadySet"];
_customID = _this select 0;
_eventID = _this select 1;
_unit = _this select 2;

if (isNull _unit) then {
	_unit = missionNamespace;
};
_eventID = format ["TFAR_event_%1", _eventID];
_handlers = _unit getVariable [_eventID, []];
{
	if (_customID == (_x select 0)) exitWith {
		_handlers = _handlers - _x;
	};
	true;
} count _handlers;

_unit setVariable [_eventID, _handlers];