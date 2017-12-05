#include "script_component.hpp"

/*
    Name: TFAR_fnc_getRadioItems

    Author(s):
        Dorbedo

    Description:
        returns the TFAR radio items of a unit (without backpack)

    Parameters:
        0: OBJECT - the unit
        1: BOOL - without duplicates (default: true)

    Returns:
        ARRAY - the radioitems of a unit

    Example:
        _itemlist = [_player] call TFAR_fnc_getRadioItems;
 */

params [["_unit", objNull, [objNull]]];

private _allItems = (assignedItems _unit);
_allItems append (items _unit);

_allItems select {((_x call TFAR_fnc_isRadio)||{_x call TFAR_fnc_isPrototypeRadio})}
