#include "script_component.hpp"

/*
  Name: TFAR_fnc_objectInterception

  Author: Dedmen
    Returns the number of voice-blocking Objects between player and _unit

  Arguments:
    None

  Return Value:
    amount of objects between player and _unit <NUMBER>

  Example:
    _unit call TFAR_fnc_objectInterception;

  Public: Yes
*/
//#TODO check isKindOf "House" and other types and transmit that. Houses isolate stronger than freestanding walls
private _ins = lineIntersectsSurfaces [
    eyepos TFAR_currentUnit,
    eyepos _this,
    TFAR_currentUnit,
    _this,
    true,
    10,
    "FIRE",
    "NONE"
];

private _localParent = objectParent TFAR_currentUnit;
private _remoteParent = objectParent _this;
private _count = {
    private _obj = (_x select 2);
    !(_obj isEqualTo _localParent || _obj isEqualTo _remoteParent) && !isPlayer _obj
  } count _ins;


_count
