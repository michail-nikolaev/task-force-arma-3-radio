#include "script_component.hpp"

/*
    Name: TFAR_fnc_getConfigProperty

    Author(s):
        NKey
        L-H

    Description:
    Gets a config property (getNumber/getText)
    Only works for CfgVehicles.

    Parameters:
    0: STRING - Item classname
    1: STRING - property
    2: ANYTHING - Default (Optional)

    Returns:
    NUMBER or TEXT or ARRAY - Result

    Example:
        [_LRradio, "tf_hasLrRadio", 0] call TFAR_fnc_getConfigProperty;
*/

params ["_item", "_property", ["_default", ""]];

//#TODO deprecate _api stuff
if ((isNil "_item") or {!(_item isEqualType "") }) exitWith {_default};//This is probably not needed... +0.01ms calltime so.... ehh...

//Caching reduces function calltime from ~0.4ms to 0.023ms
private _cacheName = (_item + _property);
private _cachedEntry = TFAR_ConfigCacheNamespace getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

if (isNumber (configFile >> "CfgVehicles" >> _item >> _property + "_api")) exitWith {
    getNumber (configFile >> "CfgVehicles" >> _item >> _property + "_api")
};

if (isNumber (configFile >> "CfgVehicles" >> _item >> _property)) exitWith {
    private _value = getNumber (configFile >> "CfgVehicles" >> _item >> _property);
    TFAR_ConfigCacheNamespace setVariable [_cacheName,_value];
    _value;
};

if (isText (configFile >> "CfgVehicles" >> _item >> _property + "_api")) exitWith {
    getText (configFile >> "CfgVehicles" >> _item >> _property + "_api")
};

if (isText (configFile >> "CfgVehicles" >> _item >> _property)) exitWith {
    private _value = getText (configFile >> "CfgVehicles" >> _item >> _property);
    TFAR_ConfigCacheNamespace setVariable [_cacheName,_value];
    _value;
};

if (isArray (configFile >> "CfgVehicles" >> _item >> _property)) exitWith {
    private _value = getArray (configFile >> "CfgVehicles" >> _item >> _property);
    TFAR_ConfigCacheNamespace setVariable [_cacheName,_value];
    _value;
};

TFAR_ConfigCacheNamespace setVariable [_cacheName,_default];

_default
