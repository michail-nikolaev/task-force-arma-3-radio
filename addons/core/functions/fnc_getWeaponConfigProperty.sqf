#include "script_component.hpp"

/*
  Name: TFAR_fnc_getVehicleConfigProperty

  Author: NKey, Garth de Wet (L-H), Dorbedo
    Gets a config property (getNumber/getText)
    Only works for CfgWeapon.

  Arguments:
    0: Item classname <STRING>
    1: property <STRING>
    2: Default Value <ANY> (default: "")

  Return Value:
    value <NUMBER|TEXT|ARRAY>

  Example:
    [_SrRadio, "tf_prototype", 0] call TFAR_fnc_getWeaponConfigProperty;

  Public: Yes
 */

params ["_item", "_property", ["_default", ""]];

private _cacheName = (_item + _property);
private _cachedEntry = GVAR(WeaponConfigCacheNamespace) getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

private _cfgProperty = (configFile >> "CfgWeapons" >> _item >> _property);

if (isNumber _cfgProperty) exitWith {
    private _value = getNumber _cfgProperty;
    GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_value];
    _value;
};

if (isText _cfgProperty) exitWith {
    private _value = getText _cfgProperty;
    GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_value];
    _value;
};

if (isArray _cfgProperty) exitWith {
    private _value = getArray _cfgProperty;
    GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_value];
    _value;
};

GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_default];

_default
