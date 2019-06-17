#include "script_component.hpp"

/*
  Name: TFAR_fnc_instanciateRadios

  Author: Dorbedo
    Replaces all prototype radios

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_instanciateRadiosServer;

  Public: No
*/

if !(isServer) exitWith {};

{
    private _unit = _x;
    private _newRadios = [];
    {
            private _id = [[_x], _unit] call TFAR_fnc_instanciateRadios;
            private _newItem = format["%1_%2", _x, _id];
            _unit linkItem _newItem;
            _newRadios pushBack _newItem;
    } forEach (assignedItems _unit) select {_x call TFAR_fnc_isPrototypeRadio};

    private _allItems = ((getItemCargo (uniformContainer _unit)) select 0);
    _allItems append ((getItemCargo (vestContainer _unit)) select 0);
    _allItems append ((getItemCargo (backpackContainer _unit)) select 0);

    {
            private _id = [[_x], _unit] call TFAR_fnc_instanciateRadios;
            _unit removeItem _x;
            private _newItem = format["%1_%2", _x, _id];
            if (_unit canAdd _newItem) then {
                _unit addItem _newItem;
                _newRadios pushBack _newItem;
            };
    } forEach _allItems select {_x call TFAR_fnc_isPrototypeRadio};

    ["TFAR_event_OnRadiosReceived", [_unit, _newRadios], _unit] call CBA_fnc_targetEvent;
} forEach (playableUnits);
