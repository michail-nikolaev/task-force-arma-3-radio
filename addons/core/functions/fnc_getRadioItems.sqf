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
 
params [["_unit", objNull, [objNull]], ["_withoutDuplicated", true, [true]]];

private _allItems = (assignedItems _unit);
_allItems append ((getItemCargo (uniformContainer _unit)) select 0);
_allItems append ((getItemCargo (vestContainer _unit)) select 0);
_allItems append ((getItemCargo (backpackContainer _unit)) select 0);
If (_withoutDuplicated) then {
    _allItems = _allItems arrayIntersect _allItems;//Remove duplicates
};

_allItems select {!(getText(configFile >> "CfgWeapons" >> _x >> "tf_parent") isEqualTo "")}
