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
private _cachedEntry = TFAR_ConfigWeaponCacheNamespace getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

_cachedEntry = ([_this, "tf_radio", 0] call DFUNC(getConfigWeaponProperty)) isEqualTo 1;

TFAR_ConfigWeaponCacheNamespace setVariable [_cacheName,_cachedEntry];

_cachedEntry
