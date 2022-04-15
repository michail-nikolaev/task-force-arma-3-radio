#include "script_component.hpp"

/*
  Name: TFAR_fnc_haveDDRadio

  Author: NKey, Garth de Wet (L-H)
    Returns whether the player has a DD radio.

  Arguments:
    None

  Return Value:
    has a DD <BOOL>

  Example:
    _hasDD = call TFAR_fnc_haveDDRadio;

  Public: Yes
*/

 private _lastCache = GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_haveDDRadio_lastCache";
 if (_lastCache > TFAR_lastLoadoutChange) exitWith {GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_haveDDRadio_CachedResult"};

 if (isNil "TFAR_currentUnit" || {isNull (TFAR_currentUnit)}) exitWith {false};

private _checkForRadio = {
    if !(call TFAR_fnc_haveSWRadio) exitWith {false};

    private _hasDDRadio = getNumber(configFile >> "CfgWeapons" >> (vest TFAR_currentUnit) >> "tf_hasDDradio");

    if (_hasDDRadio isEqualTo 1) exitWith {true};

    false;
};

private _result = call _checkForRadio;

 GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveDDRadio_lastCache",diag_tickTime-0.1];
 GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveDDRadio_CachedResult",_result];

 _result
