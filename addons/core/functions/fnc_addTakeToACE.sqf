#include "script_component.hpp"

/*
    Name: TFAR_fnc_addTakeToACE

    Author(s):
        Dorbedo

    Description:
        Used to provide an array of ace actions to be used as children actions in the interact menu.

    Parameters:
        0: OBJECT - the unit who gets the radio
        1: OBJECT - the unit who loses the radio

    Returns:
        An array of children ACE actions.

    Example:
        _children = [_target, _player] call TFAR_fnc_addTakeToACE;
 */
params ["_target", "_unit"];

private _children = [];

{
    private _cfg = ConfigFile >> "CfgWeapons" >> _x;
    _children pushBack
        [
            [
                format["TFAR_takeRadio_%1",_x],
                format[localize LSTRING(TAKE),getText(_cfg >> "displayName")],
                getText(_cfg >> "picture"),
                {call TFAR_fnc_takeRadio},
                {call TFAR_fnc_canTakeRadio},
                {},
                _x
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _target
        ];
    nil;
} count (_target call TFAR_fnc_getRadioItems);

{
    private _cfg = ConfigFile >> "CfgVehicles" >> typeOf (_x select 0);
    _children pushBack
        [
            [
                format["TFAR_takeRadio_%1",_x],
                format[localize LSTRING(TAKE),getText(_cfg >> "displayName")],
                getText(_cfg >> "picture"),
                {call TFAR_fnc_takeRadio},
                {call TFAR_fnc_canTakeRadio},
                {},
                _x
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _target
        ];
    nil;
} count ((_target call TFAR_fnc_lrRadiosList) select {(_x select 0) call TFAR_fnc_isBackpackRadio});

_children
