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
    //#TODO https://community.bistudio.com/wiki/isAbleToBreathe
    if ((vest TFAR_currentUnit) == "V_RebreatherB") exitWith {true};

    private _rebreather = configFile >> "CfgWeapons" >> "V_RebreatherB";
    private _currentVest = configFile >> "CfgWeapons" >> (vest TFAR_currentUnit);
    [_currentVest, _rebreather] call CBA_fnc_inheritsFrom
};

private _result = call _checkForRadio;

 GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveDDRadio_lastCache",diag_tickTime-0.1];
 GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_haveDDRadio_CachedResult",_result];

 _result
