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

if (_target call DFUNC(isStaticRadio)) then {
    private _radiotype = typeOf _target;
    _children pushBack [
        [
            format["TFAR_interaction_LRradio_%1", _radiotype],
            [_radiotype, "displayName", ""] call TFAR_fnc_getVehicleConfigProperty,
            [_radiotype, "picture", ""] call TFAR_fnc_getVehicleConfigProperty,
            {},
            {true},
            {[
                [_target, _this select 2] call FUNC(getExternalUsageChildren)
            ]},
            [_target, "radio_settings"]
        ] call ACE_Interact_Menu_fnc_createAction,
        [],
        _target
    ];
};

_children
