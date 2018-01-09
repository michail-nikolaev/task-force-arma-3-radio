#include "script_component.hpp"

/*
  Name: TFAR_fnc_getRadioItems

  Author: Dorbedo
    returns the TFAR radio items of a unit (without backpack)

  Arguments:
    0: the unit <OBJECT>
    1: without duplicates <BOOL> (Default: true)

  Return Value:
    the radioitems of a unit <ARRAY>

  Example:
    _itemlist = [_player] call TFAR_fnc_getRadioItems;

  Public: Yes
 */

params [["_unit", objNull, [objNull]]];

private _allItems = (assignedItems _unit);
_allItems append (items _unit);

_allItems select {((_x call TFAR_fnc_isRadio)||{_x call TFAR_fnc_isPrototypeRadio})}
