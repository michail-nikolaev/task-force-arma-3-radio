#include "script_component.hpp"

/*
  Name: TFAR_fnc_isPrototypeRadio

  Author: Garth de Wet (L-H)
    Returns if a radio is a prototype radio.

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    is Prototype radio <BOOL>

  Example:
    if ("TFAR_anprc148jem" call TFAR_fnc_isPrototypeRadio) then {
        hint "Prototype";
    };

  Public: Yes
 */

if (_this == "ItemRadio") exitWith {true};

private _cacheName = (_this+"tf_prototypebool");
private _cachedEntry = GVAR(WeaponConfigCacheNamespace) getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

_cachedEntry = ([_this, "tf_prototype", 0] call DFUNC(getWeaponConfigProperty)) isEqualTo 1;

GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_cachedEntry];

_cachedEntry
