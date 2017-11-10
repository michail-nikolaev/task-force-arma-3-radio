#include "script_component.hpp"

/*
    Name: TFAR_fnc_addStereoToACE

    Author(s):
        Dorbedo

    Description:
        Used to provide an array of ace actions to be used as children actions in the interact menu.

    Parameters:
        0: OBJECT - Unit
        1: STRING/ARRAY - the radio

    Returns:
        An array of children ACE actions.

    Example:
    _grandchildren = [_player,_player,[_radio,0]] call TFAR_fnc_addStereoToACE;
 */

params ["_unit", "_radio"];

private ["_switchFnc","_switchCheck"];

if (_radio isEqualType []) then {
    _switchFnc = {(_this select 2) call TFAR_fnc_setLrStereo;};
    _switchCheck = {!((((_this select 2)select 0) call TFAR_fnc_getLrStereo) isEqualTo ((_this select 2)select 1))};
} else {
    _switchFnc = {(_this select 2) call TFAR_fnc_setSwStereo;};
    _switchCheck = {!((((_this select 2)select 0) call TFAR_fnc_getSwStereo) isEqualTo ((_this select 2)select 1))};
};

private _grandchilds = [];

for "_i" from 0 to 2 do {
    _grandchilds pushBack [
        [
            format["TFAR_Stereo_Action_%1_%2", _radio, _i],
            localize format [LSTRING(stereo_settings_%1), _i],
            "",
            _switchFnc,
            _switchCheck,
            {},
            [_radio, _i]
        ] call ace_interact_menu_fnc_createAction,
        [],
        _unit
    ];
};

_grandchilds

