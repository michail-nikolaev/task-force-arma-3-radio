/*
 	Name: TFAR_fnc_fireEventHandlers
 	
 	Author(s):
		L-H

 	Description:
		Fires all eventhandlers associated with the passed unit
	
	Parameters:
		0: STRING - ID for event
		1: OBJECT - unit to fire events on.
		2: ANY - parameters
 	
 	Returns:
		NOTHING
 	
 	Example:
		["OnSpeak", player, [player, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
*/
private ["_eventID", "_unit", "_handlers", "_parameters"];
_eventID = _this select 0;
_unit = _this select 1;
_parameters = _this select 2;

_eventID = format ["TFAR_event_%1", _eventID];
_handlers = missionNamespace getVariable [_eventID, []];
{
	_parameters call (_x select 1);
	true;
} count _handlers;
if (isNil "_unit" || {isNull _unit}) exitWith {};
_handlers = _unit getVariable [_eventID, []];
{
	_parameters call (_x select 1);
} foreach _handlers;