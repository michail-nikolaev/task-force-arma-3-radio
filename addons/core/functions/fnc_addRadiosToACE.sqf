#include "script_component.hpp"

/*
    Name: TFAR_fnc_addRadiosToACE

    Author(s):
        Garth 'L-H' de Wet

    Description:
        Used to provide an array of ace actions to be used as children actions in the interact menu.

    Parameters:

    Returns:
        An array of children ACE actions.

    Example:
    _children = [_player] call TFAR_fnc_addRadiosToACE;
 */
params ["_unit"];

private _children = [];

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
                {},
                [_unit,_x]
            ] call ACE_Interact_Menu_fnc_createAction,
            [],
            _unit
        ];
    true;
} count (_unit call TFAR_fnc_radiosList);

_children