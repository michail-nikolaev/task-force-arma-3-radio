#include "script_component.hpp"

/*
  Name: TFAR_fnc_addEventHandler

  Author: Garth de Wet (L-H), Dedmen
    Adds an Eventhandler. Optionally only to a specific unit.

  Arguments:
    0: ID for custom handler <STRING>
    1: event name <STRING>
    2: Code to execute when event is fired. <CODE>
    3: Unit to use as filter. <OBJECT> (default: nil)

  Return Value:
    Unique ID of the event handler <NUMBER>

  Example:
    ["MyID", "OnSpeak", {
        params ["_unit","_volume"];
        hint format ["%1 is speaking %2", name _unit, _volume];
    }, player] call TFAR_fnc_addEventHandler;

  Public: Yes
*/

params ["_customID", "_eventName", "_code", ["_filterUnit",ObjNull]];
private "_eventID";//don't "optimize" this by putting private before the variable assignment

if (isNull _filterUnit) then { //global EH
    _eventID = [format ["TFAR_event_%1", _eventName], _code] call CBA_fnc_addEventHandler;
} else { //Filtering on _filterUnit
    //Add wrapper to only trigger if causing player is _filterUnit
    //Backwards-compat is ugly, we all know.
    _eventID = [format ["TFAR_event_%1", _eventName], {
            params ["_causingUnit"]; //get causing unit from TFAR_fireEventHandler
            _thisArgs params ["_wantedUnit","_code"]; //get wantedUnit and code from CBA_fnc_addEventHandlerArgs
            if (_causingUnit == _wantedUnit) then {
                _this call _code;
            };
        },[_filterUnit,_code]] call CBA_fnc_addEventHandlerArgs;
};

//Add EH ID to our register so we can later remove by _customID
//For you c++ programmers std::map<_customID,array<eventID>> _handlersHash;
private _handlersHash = missionNamespace getVariable format["tfar_EHandlers_%1",_eventName];
if (isNil "_handlersHash") then {
    _handlersHash = [[],[]] call CBA_fnc_hashCreate;//Empty hash with a default value of []
    missionNamespace setVariable [format["tfar_EHandlers_%1",_eventName],_handlersHash];
};
//Normally there should only be one registered EH per _customID but.. Humans.

private _registeredEHIDs = [_handlersHash,_customID] call CBA_fnc_hashGet;
_registeredEHIDs pushBackUnique _eventID;
//Theoretically _registeredEHIDs is a reference so we don't have to call hashSet.. But I'm too lazy to check that now
[_handlersHash,_customID,_registeredEHIDs] call CBA_fnc_hashSet;
//We were editing _handlersHash by reference so we don't call setVariable again
