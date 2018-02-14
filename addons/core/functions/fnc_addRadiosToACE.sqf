#include "script_component.hpp"

/*
  Name: TFAR_fnc_addRadiosToACE

  Author: Garth de Wet (L-H)
    Used to provide an array of ace actions to be used as children actions in the interact menu.

  Arguments:
    0: unit <OBJECT>
    1: only LR <BOOL>

  Return Value:
    children ACE actions <ARRAY>

  Example:
    _children = [_player] call TFAR_fnc_addRadiosToACE;

  Public: No
 */

params ["_unit", ["_LROnly", false]];

private _children = [];

{
    private _config = ConfigFile >> "CfgVehicles" >> typeOf (_x select 0);
    _children pushBack
        [
            [
                "radio_" + typeOf (_x select 0),
                getText(_config >> "displayName"),
                getText(_config >> "picture"),
                {
                    TF_lr_dialog_radio = (_this select 2) select 1;
                    call TFAR_fnc_onLrDialogOpen;
                },
                {true},
                {(_this select 2) call TFAR_fnc_addStereoToACE},
                [_unit,_x]
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _unit
        ];
    true;
} count (_unit call TFAR_fnc_lrRadiosList);

if (_LROnly) exitWith {_children};

{
    private _config = ConfigFile >> "CfgWeapons" >> _x;
    _children pushBack
        [
            [
                "radio_" + _x,
                getText(_config >> "displayName"),
                getText(_config >> "picture"),
                {
                    TF_sw_dialog_radio = (_this select 2) select 1;
                    call TFAR_fnc_onSwDialogOpen;
                },
                {true},
                {(_this select 2) call TFAR_fnc_addStereoToACE},
                [_unit,_x]
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _unit
        ];
    true;
} count (_unit call TFAR_fnc_radiosList);

_children
