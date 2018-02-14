#include "script_component.hpp"

/*
  Name: TFAR_fnc_getVehicleConfigProperty

  Author: NKey, Garth de Wet (L-H)
    Gets a config property (getNumber/getText)
    Only works for CfgVehicles.

  Arguments:
    0: Item classname <STRING>
    1: property <STRING>
    2: Default Value <ANY> (default: "")

  Return Value:
    value <NUMBER|TEXT|ARRAY>

  Example:
    [_LRradio, "tf_hasLrRadio", 0] call TFAR_fnc_getVehicleConfigProperty;

  Public: Yes
*/

params ["_item", "_property", ["_default", ""]];

//#TODO deprecate _api stuff
if ((isNil "_item") or {!(_item isEqualType "") }) exitWith {_default};//This is probably not needed... +0.01ms calltime so.... ehh...

//Caching reduces function calltime from ~0.4ms to 0.023ms
private _cacheName = (_item + _property);
private _cachedEntry = GVAR(VehicleConfigCacheNamespace) getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

private _cfgApiProperty = (configFile >> "CfgVehicles" >> _item >> _property + "_api");
private _cfgProperty = (configFile >> "CfgVehicles" >> _item >> _property);

if (isNumber _cfgApiProperty) exitWith {
    getNumber _cfgApiProperty
};

if (isNumber _cfgProperty) exitWith {
    private _value = getNumber _cfgProperty;
    GVAR(VehicleConfigCacheNamespace) setVariable [_cacheName,_value];
    _value;
};

if (isText _cfgApiProperty) exitWith {
    getText _cfgApiProperty
};

if (isText _cfgProperty) exitWith {
    private _value = getText _cfgProperty;
    GVAR(VehicleConfigCacheNamespace) setVariable [_cacheName,_value];
    _value;
};

if (isArray _cfgProperty) exitWith {
    private _value = getArray _cfgProperty;
    GVAR(VehicleConfigCacheNamespace) setVariable [_cacheName,_value];
    _value;
};

GVAR(VehicleConfigCacheNamespace) setVariable [_cacheName,_default];

_default
