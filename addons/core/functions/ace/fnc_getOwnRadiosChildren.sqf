#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_getOwnRadiosChildren

  Author: Garth de Wet (L-H)
    Used to provide an array of ace actions to be used as children actions in the interact menu.

  Arguments:
    0: unit <OBJECT>
    1: only LR <BOOL>

  Return Value:
    children ACE actions <ARRAY>

  Example:
    _children = [_player] call TFAR_core_fnc_getOwnRadiosChildren;

  Public: No
*/

params ["_unit", ["_LROnly", false, [false]]];

private _children = [];

{
    private _radiotype = typeOf (_x select 0);
    _children pushBack
        [
            [
                format["TFAR_selfinteraction_LRradio_%1", _radiotype],
                [_radiotype, "displayName", ""] call TFAR_fnc_getVehicleConfigProperty,
                [_radiotype, "picture"] call TFAR_fnc_getVehicleConfigProperty,
                {
                    TF_lr_dialog_radio = (_this select 2) select 1;
                    call TFAR_fnc_onLrDialogOpen;
                },
                {true},
                {/*(_this select 2) call FUNC(getStereoChildren)*/},
                [_unit,_x]
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _unit
        ];
} forEach (_unit call TFAR_fnc_lrRadiosList);

if (_LROnly) exitWith {_children};

{
    _children pushBack
        [
            [
                format["TFAR_selfinteraction_SRradio_%1", _x],
                [_x, "displayName", ""] call TFAR_fnc_getWeaponConfigProperty,
                [_x, "picture", ""] call TFAR_fnc_getWeaponConfigProperty,
                {
                    TF_sw_dialog_radio = (_this select 2) select 1;
                    call TFAR_fnc_onSwDialogOpen;
                },
                {true},
                {(_this select 2) call FUNC(getStereoChildren)},
                [_unit,_x]
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _unit
        ];
} forEach (_unit call TFAR_fnc_radiosList);

_children
