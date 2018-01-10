#include "script_component.hpp"

/*
    Name: TFAR_fnc_instanciateRadiosServer

    Author(s):
        Dorbedo

    Description:
        Replaces all prototype radios

    Parameters:
        None

    Returns:
        None

    Example:
        call TFAR_fnc_instanciateRadiosServer;
*/

if !(isServer) exitWith {};

{
    private _unit = _x;
    private _newRadios = [];
    {
        if (_x call TFAR_fnc_isPrototypeRadio) exitWith {
            private _id = [[_x], side _unit] call TFAR_fnc_instanciateRadios;
            private _newItem = format["%1_", _x, _id];
            _unit linkItem _newItem;
            _newRadios pushBack _newItem;
        };
    } forEach (assignedItems _unit);

    private _allItems = ((getItemCargo (uniformContainer _unit)) select 0);
    _allItems append ((getItemCargo (vestContainer _unit)) select 0);
    _allItems append ((getItemCargo (backpackContainer _unit)) select 0);

    {
        if (_x call TFAR_fnc_isPrototypeRadio) exitWith {
            private _id = [[_x], side _unit] call TFAR_fnc_instanciateRadios;
            _unit removeItem _x;
            private _newItem = format["%1_", _x, _id];
            if (_unit canAdd _newItem) then {
                _unit addItem _newItem;
                _newRadios pushBack _newItem;
            };
        };
    } forEach _allItems;

    ["TFAR_event_OnRadiosReceived", [_unit, _newRadios], _unit] call CBA_fnc_targetEvent;
} forEach (playableUnits);
