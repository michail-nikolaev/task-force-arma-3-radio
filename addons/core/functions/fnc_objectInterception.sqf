#include "script_component.hpp"

/*
    Name: TFAR_fnc_objectInterception

    Author(s):
        Dedmen

    Description:
        Returns the number of voice-blocking Objects between player and _unit

    Parameters:
        Nothing

    Returns:
        NUMBER: amount of objects between player and _unit

    Example:
        _unit call TFAR_fnc_objectInterception;
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

count _ins
