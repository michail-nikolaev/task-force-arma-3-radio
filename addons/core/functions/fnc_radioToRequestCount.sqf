#include "script_component.hpp"

/*
    Name: TFAR_fnc_radioToRequestCount

    Author(s):
        NKey
        L-H

    Description:
        Searches through all the items assigned to and on the player and checks if it is a prototype radio
        and then creates an array of all the classnames of the prototype radios and returns it.

    Parameters:
        BOOLEAN - Regardless of whether the radio is prototype or not, return it as a radio to be replaced.

    Returns:
        ARRAY
            0: ARRAY - List of all radio classes to be replaced.
            1: ARRAY - List of settings to be copied

    Example:
        (false call TFAR_fnc_radioToRequestCount) params ["_radiosToReplace","_TF_SettingsToCopy"];
*/

params[["_allRadios", false, [true]]];
private _to_remove = [];
private _TF_settingsToCopy = [];

{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _to_remove pushBack _x;
        _TF_settingsToCopy pushBack "";
    } else {
        if (_x call TFAR_fnc_isRadio) then {
            if ((_x call TFAR_fnc_getRadioOwner) == "") then {
                [_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
            };
            if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
                _to_remove pushBack _x;
                _TF_settingsToCopy pushBack _x;
            };
        };
    };
    nil
} count (assignedItems TFAR_currentUnit);

private _allItems = ((getItemCargo (uniformContainer TFAR_currentUnit)) select 0);
_allItems append ((getItemCargo (vestContainer TFAR_currentUnit)) select 0);
_allItems append ((getItemCargo (backpackContainer TFAR_currentUnit)) select 0);

{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _to_remove pushBack _x;
        _TF_settingsToCopy pushBack "";
    } else {
        if (_x call TFAR_fnc_isRadio) then {
            if ((_x call TFAR_fnc_getRadioOwner) == "") then {
                [_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
            };
            if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
                _to_remove pushBack _x;
                _TF_settingsToCopy pushBack _x;
            };
        };
    };
    nil
} count _allItems;

[_to_remove,_TF_settingsToCopy]
