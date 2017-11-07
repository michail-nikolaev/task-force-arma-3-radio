#include "script_component.hpp"

/*
    Name: TFAR_fnc_getConfigWeaponProperty

    Author(s):
        Dorbedo

    Description:
    Gets a config property (getNumber/getText/getArray)
    Only works for CfgWeapon.

    Parameters:
    0: STRING - Item classname
    1: STRING - property
    2: ANYTHING - Default (Optional)

    Returns:
    NUMBER or TEXT or ARRAY - Result

    Example:
        [_SrRadio, "tf_prototype", 0] call TFAR_fnc_getConfigWeaponProperty;
*/

params ["_item", "_property", ["_default", ""]];

private _cacheName = (_item + _property);
private _cachedEntry = TFAR_ConfigWeaponCacheNamespace getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

private _cfgProperty = (configFile >> "CfgWeapons" >> _item >> _property);

if (isNumber _cfgProperty) exitWith {
    private _value = getNumber _cfgProperty;
    TFAR_ConfigWeaponCacheNamespace setVariable [_cacheName,_value];
    _value;
};

if (isText _cfgProperty) exitWith {
    private _value = getText _cfgProperty;
    TFAR_ConfigWeaponCacheNamespace setVariable [_cacheName,_value];
    _value;
};

if (isArray _cfgProperty) exitWith {
    private _value = getArray _cfgProperty;
    TFAR_ConfigWeaponCacheNamespace setVariable [_cacheName,_value];
    _value;
};

TFAR_ConfigWeaponCacheNamespace setVariable [_cacheName,_default];

_default
