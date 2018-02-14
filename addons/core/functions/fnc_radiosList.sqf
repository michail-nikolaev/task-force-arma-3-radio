#include "script_component.hpp"

/*
  Name: TFAR_fnc_radiosList

  Author: NKey
    List of all the player's SW radios.

  Arguments:
    unit <OBJECT>

  Return Value:
    List of all the player's SW radios. <ARRAY>

  Example:
    _radios = TFAR_currentUnit call TFAR_fnc_radiosList;

  Public: Yes
*/

private _fetchItems = {
    private _allItems = (assignedItems _this);
    _allItems append ((getItemCargo (uniformContainer _this)) select 0);
    _allItems append ((getItemCargo (vestContainer _this)) select 0);
    _allItems append ((getItemCargo (backpackContainer _this)) select 0);
    _allItems = _allItems arrayIntersect _allItems;//Remove duplicates

    private _result = [];
    {
        if (_x call TFAR_fnc_isRadio) then {
            _result pushBack _x;
        };
        true;
    } count _allItems;
    _result
};

//We only cache local player because TFAR_lastLoadoutChange only reflects local player
if (_this != TFAR_currentUnit) exitWith {_this call _fetchItems};

//Caching
private _lastCache = GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_radiosList_lastCache";
if (_lastCache > TFAR_lastLoadoutChange) exitWith {GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_radiosList_CachedRadios"};

private _result = _this call _fetchItems;

GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_radiosList_lastCache",diag_tickTime-0.1];//#TODO make macros from these
GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_radiosList_CachedRadios",_result];

_result
