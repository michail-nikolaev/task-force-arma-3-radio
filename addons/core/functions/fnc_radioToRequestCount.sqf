#include "script_component.hpp"

/*
  Name: TFAR_fnc_radioToRequestCount

  Author: NKey, Garth de Wet (L-H), Dorbedo
    Searches through all the items assigned to and on the player and checks if it is a prototype radio
    and then creates an array of all the classnames of the prototype radios and returns it.

  Arguments:
    Regardless of whether the radio is prototype or not, return it as a radio to be replaced. <BOOL>

  Return Value:
    0: List of all radio classes to be replaced. <ARRAY>
    1: List of settings to be copied. <ARRAY>

  Example:
    (false call TFAR_fnc_radioToRequestCount) params ["_radiosToReplace","_TF_SettingsToCopy"];

  Public: Yes
*/

params[["_allRadios", false, [true]]];

private _radiosToRequest = [];
{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _radiosToRequest pushBack _x;
    } else {
        if (_x call TFAR_fnc_isRadio) then {
            if ((_x call TFAR_fnc_getRadioOwner) == "") then {
                [_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
            };
            if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
                _radiosToRequest pushBack _x;
            };
        };
    };
    nil
} count (assignedItems TFAR_currentUnit);

private _linkFirstItem = !(_radiosToRequest isEqualTo []);

private _allItems = ((getItemCargo (uniformContainer TFAR_currentUnit)) select 0);
_allItems append ((getItemCargo (vestContainer TFAR_currentUnit)) select 0);
_allItems append ((getItemCargo (backpackContainer TFAR_currentUnit)) select 0);

{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _radiosToRequest pushBack _x;
    } else {
        if (_x call TFAR_fnc_isRadio) then {
            if ((_x call TFAR_fnc_getRadioOwner) == "") then {
                [_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
            };
            if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
                _radiosToRequest pushBack _x;
            };
        };
    };
    nil
} count _allItems;

[_radiosToRequest, _linkFirstItem]
