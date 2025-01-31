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

// Multithread the lineIntersects, this function only works in 2.20 (and is only called there);

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

{
  private _ins = _x;
  private _unit = _this select _forEachIndex;

  private _localParent = objectParent TFAR_currentUnit;
  private _remoteParent = objectParent _unit;
  private _count = {
      private _obj = (_x select 2);
      !(_obj isEqualTo _localParent || _obj isEqualTo _remoteParent) && !isPlayer _obj
    } count _ins;

    GVAR(ObjectInterceptionCache) set [hashValue _unit, _count];
}
forEach _results;
