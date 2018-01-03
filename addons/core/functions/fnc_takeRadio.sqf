#include "script_component.hpp"

/*
 * Name: TFAR_fnc_takeRadio
 *
 * Author: Dorbedo
 * Removes the radio from the target unit and adds the radio to another unit
 *
 * Arguments:
 * 0: the unit who gets the radio <OBJECT>
 * 1: the unit who loses the radio <OBJECT>
 * 2: the radio to be taken <STRING/ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_target, _player, "TFAR_anprc_152_12"] call TFAR_fnc_takeRadio;
 *
 * Public: No
 */

params ["_target", "_unit", "_radio"];

if (_radio isEqualType "") then {
    if (_radio in (assignedItems _target)) then {
        _target unlinkItem _radio;
    } else {
        _target removeItem _radio;
    };
    _unit addItem _radio;
} else {
    _unit addBackpackGlobal (typeOf (_radio select 0));
    private _newBackpack = unitBackpack _unit;
    private _oldBackpack = unitBackpack _target;
    {
        _newBackpack setVariable [_x, _oldBackpack getVariable _x];
        nil;
    } count (allVariables _oldBackpack);
    removeBackpackGlobal _target;
};
