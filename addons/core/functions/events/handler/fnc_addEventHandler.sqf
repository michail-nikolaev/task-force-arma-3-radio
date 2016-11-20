#include "script_component.hpp"

/*
    Name: TFAR_fnc_addEventHandler

    Author(s):
        L-H, Dedmen

    Description:
        Adds an Eventhandler. Optionally only to a specific unit.

    Parameters:
        0: STRING - ID for custom handler - used for TFAR_fnc_removeEventHandler
        1: STRING - Name of event
        2: CODE - Code to execute when event is fired.
        (OPTIONAL) 3: OBJECT - Unit to use as filter. Only executes Handler if causing unit equals this.

    Returns:
        NUMBER: Unique ID of the event handler (can be used with CBA_fnc_removeEventHandler).

    Example:
        ["MyID", "OnSpeak", {
            params ["_unit","_volume"];
            hint format ["%1 is speaking %2", name _unit, _volume];
        }, player] call TFAR_fnc_addEventHandler;
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
[_handlersHash,_customID,{
    private _registeredEHIDs = [_handlersHash,_customID] call CBA_fnc_hashGet;
    _registeredEHIDs pushBackUnique _eventID;
    _registeredEHIDs;
}] call CBA_fnc_hashSet;
//We were editing _handlersHash by reference so we don't call setVariable again
