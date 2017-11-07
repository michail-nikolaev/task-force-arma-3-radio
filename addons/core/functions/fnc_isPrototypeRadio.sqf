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

private _cacheName = (_this+"tf_prototypebool");
private _cachedEntry = TFAR_ConfigWeaponCacheNamespace getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

_cachedEntry = ([_this, "tf_prototype", 0] call DFUNC(getConfigWeaponProperty)) isEqualTo 1;

TFAR_ConfigWeaponCacheNamespace setVariable [_cacheName,_cachedEntry];

_cachedEntry
