#include "script_component.hpp"

/*
  Name: TFAR_fnc_swRadioMenu

  Author: NKey, Garth de Wet (L-H)
    Returns a list of SW radios if more than one is on the player.

  Arguments:
    None

  Return Value:
    Flexi-menu <ARRAY>

  Example:
    call TFAR_fnc_swRadioMenu;

  Public: No
*/

private _menu = [];
private _radios = TFAR_currentUnit call TFAR_fnc_radiosList;
if ((count _radios > 1) or {(count _radios == 1) and !(call TFAR_fnc_haveSWRadio)}) then {
    private _menuDef = ["main", localize LSTRING(select_radio), "buttonList", "", false];
    private _positions = [];
    {
        private _command = format["TF_sw_dialog_radio = '%1';[{call TFAR_fnc_onSwDialogOpen;}, [], 0.2] call CBA_fnc_waitAndExecute;", _x];
        private _submenu = "";
        private _active_radio = call TFAR_fnc_activeSwRadio;
        if ((isNil "_active_radio") or {_x != _active_radio}) then{
            _command = format["TF_sw_dialog_radio = '%1';", _x];
            _submenu = "_this call TFAR_fnc_swRadioSubMenu";
        };
        private _position = [
            ([_x, "displayName", ""] call DFUNC(getWeaponConfigProperty)),
            _command,
            ([_x, "picture", ""] call DFUNC(getWeaponConfigProperty)),
            "",
            _submenu,
            -1,
            true,
            true
        ];
        _positions pushBack _position;
    } forEach _radios;
    _menu = [
        _menuDef,
        _positions
    ];
} else {
    if (call TFAR_fnc_haveSWRadio) then {
        TF_sw_dialog_radio = call TFAR_fnc_activeSwRadio;
        call TFAR_fnc_onSwDialogOpen;
    };
};
_menu
