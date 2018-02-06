/*
    Name: TFAR_fnc_replaceSwRadiosServer

    Author(s):
        gandjustas

    Description:
        Handles (on server) getting switching radios, handles whether a manpack must be added to the player or not.

    Parameters:
        0: OBJECT - unit to replace radios
        1: STRING - default radio class to replace ItemRadio

    Returns:
        Nothing

    Example:
        _unit remoteExec ["TFAR_fnc_replaceSwRadiosServer", 2];
*/
params ["_unit", "_defaultRadio"];
private _replacedRadios = [];

private _replaceRadio = {
    params ["_radio"];
    if (_radio == "ItemRadio") then {
        _radio = _defaultRadio;
    };
    _radio call TFAR_fnc_instanciateRadio
};

{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        //replace		
        private _radio = (_x call _replaceRadio);
        _unit linkItem _radio;
        _replacedRadios pushBack _radio;
    };	
} forEach (assignedItems _unit);

{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _unit removeItem _x;
        private _radio = (_x call _replaceRadio);
        _unit addItem _radio;
        _replacedRadios pushBack _radio;
    };
} forEach (_unit call _fetchItems);

["TFAR_event_OnRadiosReceived",[_unit,_replacedRadios], _unit] call CBA_fnc_targetEvent;
