#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_getRadiosChildren

  Author: Dorbedo
    adds the interaction children

  Arguments:
    0: target <OBJECT>
    1: calling player <OBJECT>

  Return Value:
    children ace interaction <ARRAY>

  Example:
    _children = [_target, _player] call TFAR_core_fnc_getRadiosChildren;

  Public: No
*/

params ["_target", "_unit"];

private _children = [];

{
    private _radiotype = typeOf (_x select 0);
    _children pushBack
        [
            [
                format["TFAR_interaction_LRradio_%1", _radiotype],
                [_radiotype, "displayName", ""] call TFAR_fnc_getVehicleConfigProperty,
                [_radiotype, "picture", ""] call TFAR_fnc_getVehicleConfigProperty,
                {},
                {true},
                {
                    ([_target, _x] call FUNC(getTakeChildren))
                },
                _x
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _target
        ];
} forEach ((_target call TFAR_fnc_lrRadiosList) select {(_x select 0) call TFAR_fnc_isBackpackRadio});

{
    _children pushBack
        [
            [
                format["TFAR_interaction_SRradio_%1", _x],
                [_x, "displayName", ""] call TFAR_fnc_getWeaponConfigProperty,
                [_x, "picture", ""] call TFAR_fnc_getWeaponConfigProperty,
                {},
                {true},
                {
                    ([_target, _x] call FUNC(getTakeChildren))
                },
                _x
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _target
        ];
} forEach (_target call TFAR_fnc_getRadioItems);

_children
