#include "script_component.hpp"

/*
  Name: TFAR_fnc_isRadio

  Author: NKey, Garth de Wet (L-H)
    Checks whether the passed radio is a TFAR radio.

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    is a radio <BOOL>

  Example:
    _isRadio = "NotARadioClass" call TFAR_fnc_isRadio;

  Public: Yes
 */

private _cacheName = (_this+"tf_radiobool");
private _cachedEntry = GVAR(WeaponConfigCacheNamespace) getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

_cachedEntry = ([_this, "tf_radio", 0] call DFUNC(getWeaponConfigProperty)) isEqualTo 1;

GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_cachedEntry];

_cachedEntry
