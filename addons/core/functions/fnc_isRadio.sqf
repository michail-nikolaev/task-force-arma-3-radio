#include "script_component.hpp"

/*
    Name: TFAR_fnc_isRadio

    Author(s):
        NKey
        L-H

    Description:
        Checks whether the passed radio is a TFAR radio.

    Parameters:
        STRING - Radio classname

    Returns:
        BOOLEAN

    Example:
        _isRadio = "NotARadioClass" call TFAR_fnc_isRadio;
*/

//This is the same caching as in fnc_getConfigProperty. But we don't need that special stuff for CfgVehicles in getConfigProperty
//So we implement the same caching for this more slim function.

private _cacheName = (_this+"tf_radio");
private _cachedEntry = TFAR_ConfigCacheNamespace getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

private _result = getNumber (configFile >> "CfgWeapons" >> _this >> "tf_radio");
if (!isNil "_result") exitWith {TFAR_ConfigCacheNamespace setVariable [_cacheName,_result == 1];_result == 1};

TFAR_ConfigCacheNamespace setVariable [_cacheName,false];
false
