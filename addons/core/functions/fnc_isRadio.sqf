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

private _cacheName = (_this+"tf_radiobool");
private _cachedEntry = GVAR(WeaponConfigCacheNamespace) getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

_cachedEntry = ([_this, "tf_radio", 0] call DFUNC(getWeaponConfigProperty)) isEqualTo 1;

GVAR(WeaponConfigCacheNamespace) setVariable [_cacheName,_cachedEntry];

_cachedEntry
