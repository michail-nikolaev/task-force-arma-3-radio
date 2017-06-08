#include "script_component.hpp"

/*
    Name: TFAR_fnc_haveSWRadio

    Author(s):

    Description:
        Returns whether the player has a SW radio

    Parameters:
    Nothing

    Returns:
    BOOLEAN

    Example:
    _hasSW = call TFAR_fnc_haveSWRadio;
 */

//Caching
private _lastCache = TFAR_ConfigCacheNamespace getVariable "TFAR_fnc_haveSWRadio_lastCache";
if (_lastCache > TFAR_lastLoadoutChange) exitWith {TFAR_ConfigCacheNamespace getVariable "TFAR_fnc_haveSWRadio_CachedResult"};

private _result = false;

if (isNil "TFAR_currentUnit" || {isNull (TFAR_currentUnit)}) exitWith {false};

{
    if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
    true;
} count (assignedItems TFAR_currentUnit);

if (player != TFAR_currentUnit) then {
    {
        if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
        true;
    } count (assignedItems player);
};

TFAR_ConfigCacheNamespace setVariable ["TFAR_fnc_haveSWRadio_lastCache",diag_tickTime-0.1];
TFAR_ConfigCacheNamespace setVariable ["TFAR_fnc_haveSWRadio_CachedResult",_result];

_result
