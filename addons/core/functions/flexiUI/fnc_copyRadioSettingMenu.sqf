#include "script_component.hpp"

/*
    Name: TFAR_fnc_copyRadioSettingMenu

    Author(s):
        NKey

    Description:
        Returns a sub menu for radio settings copying.

    Parameters:
        Nothing

    Returns:
        ARRAY: CBA UI menu.

    Example:
        Called internally by CBA UI
*/

private _menu = [];

private _menuDef = ["main", localize "STR_select_action_copy_settings_from", "buttonList", "", false];
private _positions = [];
{
    if (((_x call TFAR_fnc_getSwRadioCode) == (TF_sw_dialog_radio call TFAR_fnc_getSwRadioCode)) and {TF_sw_dialog_radio != _x}) then {
        private _command = format["['%1',TF_sw_dialog_radio] call TFAR_fnc_copySettings;", _x];
        _position = [
            ([_x, "displayName", ""] call DFUNC(getConfigWeaponProperty)),
            _command,
            ([_x, "picture", ""] call DFUNC(getConfigWeaponProperty)),
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
