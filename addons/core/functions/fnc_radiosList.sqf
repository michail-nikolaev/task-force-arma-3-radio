#include "script_component.hpp"

/*
    Name: TFAR_fnc_radiosList

    Author(s):
        NKey

    Description:
        List of all the player's SW radios.

    Parameters:
        0: OBJECT: unit

    Returns:
        ARRAY - List of all the player's SW radios.

    Example:
        _radios = TFAR_currentUnit call TFAR_fnc_radiosList;
*/

private _fetchItems = {
    private _allItems = (assignedItems _this) + (items _this);
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
private _lastCache = TFAR_ConfigCacheNamespace getVariable "TFAR_fnc_radiosList_lastCache";
if (_lastCache > TFAR_lastLoadoutChange) exitWith {TFAR_ConfigCacheNamespace getVariable "TFAR_fnc_radiosList_CachedRadios"};

private _result = _this call _fetchItems;

TFAR_ConfigCacheNamespace setVariable ["TFAR_fnc_radiosList_lastCache",diag_tickTime-0.1];//#TODO make macros from these
TFAR_ConfigCacheNamespace setVariable ["TFAR_fnc_radiosList_CachedRadios",_result];

_result
