#include "script_component.hpp"

/*
  Name: TFAR_fnc_objectInterceptionBulkToCache

  Author: Dedmen
    Calculates lineIntersects using multithreading and caches them

  Arguments:
    Objects to calculate interception and fill into cache <ARRAY>

  Return Value:
    Nothing

  Example:
    [a,b,c] call TFAR_fnc_objectInterceptionBulkToCache;

  Public: Yes
*/
//#TODO check isKindOf "House" and other types and transmit that. Houses isolate stronger than freestanding walls

// Multithread the lineIntersects, this function requires minimum game 2.20

private _requests = _this apply {
    [
        eyepos TFAR_currentUnit,
        eyepos _x,
        TFAR_currentUnit,
        _x,
        true,
        10,
        "FIRE",
        "NONE"
    ];
};

private _results = lineIntersectsSurfaces [_requests];

private _localParent = objectParent TFAR_currentUnit;
private _exclList = [_localParent, objNull]; // Second one will be filled in with remoteParent

{
    private _unit = _this select _forEachIndex;

    _exclList set [1, objectParent _unit];

    _results set [_forEachIndex, [
      hashValue _unit, 
      {
        //private _obj = (_x select 2);
        !((_x select 2) in _exclList) && !isPlayer (_x select 2)
      } count _x
    ]];
} forEach _results;

GVAR(ObjectInterceptionCache) insert _results;