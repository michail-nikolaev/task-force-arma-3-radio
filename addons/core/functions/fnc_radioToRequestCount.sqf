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

private _to_remove = [];
private _allRadios = _this;

private _classes = call TFAR_fnc_getDefaultRadioClasses;
private _personalRadio = _classes select 1;
private _riflemanRadio = _classes select 2;
private _defaultRadio = _riflemanRadio;

if ((TFAR_givePersonalRadioToRegularSoldier) or {leader TFAR_currentUnit == TFAR_currentUnit} or {rankId TFAR_currentUnit >= 2}) then {
    _defaultRadio = _personalRadio;
};

private _TF_settingsToCopy = [];
{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _to_remove pushBack _x;
        TFAR_RadioReqLinkFirstItem = true;
    } else {
        if (_x call TFAR_fnc_isRadio) then {
            if ((_x call TFAR_fnc_getRadioOwner) == "") then {
                [_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
            };
            if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
                _to_remove pushBack _x;
                _TF_settingsToCopy set [0, _x];
                TFAR_RadioReqLinkFirstItem = true;
            };
        };
    };
    true;
} count (assignedItems TFAR_currentUnit);

private _uniqueItems = (items TFAR_currentUnit);
_uniqueItems = _uniqueItems arrayIntersect _uniqueItems;//Remove duplicates //#BUG this causes that only one Radio will be requested per request if you have multiple with same classname

{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _to_remove pushBack _x;
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
    true;
} count _uniqueItems;

//Remove old items from Players inventory
{
    TFAR_currentUnit unassignItem _x;
    TFAR_currentUnit removeItem _x;
    if (_x == "ItemRadio") then {
        _to_remove set [_forEachIndex, _defaultRadio];
    };
} forEach _to_remove;

[_to_remove,_TF_settingsToCopy]
