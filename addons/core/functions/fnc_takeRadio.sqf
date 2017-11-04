#include "script_component.hpp"

/*
    Name: TFAR_fnc_takeRadio

    Author(s):
        Dorbedo

    Description:
        Removes the radio from the target unit and adds the radio to another unit

    Parameters:
        0: OBJECT - the unit who gets the radio
        1: OBJECT - the unit who loses the radio
        2: STRING/ARRAY - the radio to be taken

    Returns:
        Nothing

    Example:
        [_target, _player, "TFAR_anprc_152_12"] call TFAR_fnc_takeRadio;
*/

params ["_target", "_unit", "_radio"];

If (_radio isEqualType "") then {
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
