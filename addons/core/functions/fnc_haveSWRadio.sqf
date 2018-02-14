#include "script_component.hpp"

/*
  Name: TFAR_fnc_haveSWRadio

  Author: NKey, Garth de Wet (L-H)
    Returns whether the player has a SR radio

  Arguments:
    None

  Return Value:
    has SR <BOOL>

  Example:
    _hasSW = call TFAR_fnc_haveSWRadio;

  Public: Yes
 */

//Caching
private _lastCache = GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_haveSWRadio_lastCache";
if (_lastCache > TFAR_lastLoadoutChange) exitWith {GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_haveSWRadio_CachedResult"};

private _result = false;

if (isNil "TFAR_currentUnit" || {isNull (TFAR_currentUnit)}) exitWith {false};

{
    if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
    true;
} count (assignedItems TFAR_currentUnit);

GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveSWRadio_lastCache",diag_tickTime-0.1];
GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveSWRadio_CachedResult",_result];

_result
