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
    2: Should the first Item be linked to Radio slot? <BOOL>

  Example:
    (false call TFAR_fnc_radioToRequestCount) params ["_radiosToReplace","_settingsToCopy","_linkFirstItem"];

  Public: Yes
*/

params[["_allRadios", false, [true]]];

private _settingsToCopy = [];

private _radioSelector = {
    (_x call TFAR_fnc_isPrototypeRadio) || {//select all non-instanciated radios, or..
        (_x call TFAR_fnc_isRadio) && {//...if they are already instanciated...
            private _radioOwner = _x call TFAR_fnc_getRadioOwner;
            private _playerUID = getPlayerUID player;
            if (_radioOwner == "") then {//...but not owned by anyone, just take ownership
                [_x, _playerUID] call TFAR_fnc_setRadioOwner;
                _radioOwner = _playerUID;
            };
            //...and owned by someone else then we want to select it to be replaced, to give the unit it's own Radio
            private _condition = _allRadios || {_radioOwner != _playerUID};
            if (_condition) then {_settingsToCopy pushBackUnique _x};
            _condition;
        }
    }
};

private _radiosToRequest = (assignedItems TFAR_currentUnit) select _radioSelector;

//If we had a Radio assigned to the Radio slot before, then we want to assign one to it again when we get the instanciated radios back
private _linkFirstItem = !(_radiosToRequest isEqualTo []);

//could use CBA_fnc_uniqueUnitItems here but we don't want assignedItems
private _allItems = ((getItemCargo (uniformContainer TFAR_currentUnit)) select 0);
_allItems append ((getItemCargo (vestContainer TFAR_currentUnit)) select 0);
_allItems append ((getItemCargo (backpackContainer TFAR_currentUnit)) select 0);

_radiosToRequest append (_allItems select _radioSelector);

[_radiosToRequest, _settingsToCopy, _linkFirstItem]
