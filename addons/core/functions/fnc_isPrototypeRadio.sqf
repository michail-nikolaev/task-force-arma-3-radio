#include "script_component.hpp"

/*
    Name: TFAR_fnc_isPrototypeRadio

    Author(s): Garth de Wet (LH)

    Description:
    Returns if a radio is a prototype radio.

    Parameters:
    0: STRING - Radio classname

    Returns:
    BOOLEAN - True if prototype, false if actual radio.

    Example:
    if ("TFAR_anprc148jem" call TFAR_fnc_isPrototypeRadio) then {
        hint "Prototype";
    };
*/

if (_this == "ItemRadio") exitWith {true};


//This is the same caching as in fnc_getConfigProperty. But we don't need that special stuff for CfgVehicles in getConfigProperty
//So we implement the same caching for this more slim function.

private _cacheName = (_this+"tf_prototype");
private _cachedEntry = TFAR_ConfigCacheNamespace getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

private _result = getNumber (configFile >> "CfgWeapons" >> _this >> "tf_prototype");
if (!isNil "_result") exitWith {TFAR_ConfigCacheNamespace setVariable [_cacheName,_result == 1];_result == 1};

TFAR_ConfigCacheNamespace setVariable [_cacheName,false];
false
