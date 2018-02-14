#include "script_component.hpp"

/*
  Name: TFAR_fnc_copyRadioSettingMenu

  Author: NKey
    Returns a sub menu for radio settings copying.

  Arguments:
    None

  Return Value:
    Flexi-menu <ARRAY>

  Example:
    call TFAR_fnc_copyRadioSettingMenu;

  Public: No
*/

private _menu = [];

private _menuDef = ["main", localize LSTRING(select_action_copy_settings_from), "buttonList", "", false];
private _positions = [];
{
    if (((_x call TFAR_fnc_getSwRadioCode) == (TF_sw_dialog_radio call TFAR_fnc_getSwRadioCode)) and {TF_sw_dialog_radio != _x}) then {
        private _command = format["['%1',TF_sw_dialog_radio] call TFAR_fnc_copySettings;", _x];
        _position = [
            ([_x, "displayName", ""] call DFUNC(getWeaponConfigProperty)),
            _command,
            ([_x, "picture", ""] call DFUNC(getWeaponConfigProperty)),
            "",
            "",
            -1,
            true,
            true
        ];
        _positions pushBack _position;
    };
} forEach (TFAR_currentUnit call TFAR_fnc_radiosList);
_menu =
[
    _menuDef,
    _positions
];
_menu
