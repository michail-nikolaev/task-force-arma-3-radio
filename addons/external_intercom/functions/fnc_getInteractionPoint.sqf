#include "script_component.hpp"

/*
  Name: TFAR_fnc_getInteractionPoint

  Author: Arend(Saborknight)
    Gets the vehicle's interaction point for the telephone, either inferred or
    by using a custom position if it was defined in the vehicle's class

  Arguments:
    0: Vehicle object <OBJECT>

  Return Value:
    Interaction Position (AGL) <POSITION>

  Example:
    [_vehicle] call TFAR_fnc_getInteractionPoint;

  Public: Yes
*/
params ["_vehicle"];

// Cache position
private _cacheName = format ["%1_externalIntercomInteractionPoint", _vehicle];
private _cachedEntry = EGVAR(core,VehicleConfigCacheNamespace) getVariable _cacheName;
if (!isNil "_cachedEntry") exitWith {_cachedEntry};

private _customPosition = [(typeOf _vehicle), "TFAR_ExternalIntercomInteractionPoint"] call TFAR_fnc_getVehicleConfigProperty;

// If there's a custom position, then don't bother calculating
if (_customPosition isNotEqualTo "") then {
    if (_customPosition isEqualType "") then {
        _customPosition = _vehicle selectionPosition _customPosition;

        if (_customPosition isNotEqualTo [0, 0, 0]) exitWith {
            EGVAR(core,VehicleConfigCacheNamespace) setVariable [_cacheName, _customPosition];
            _customPosition;
        };
    };

    if (_customPosition isEqualType []) exitWith {
        EGVAR(core,VehicleConfigCacheNamespace) setVariable [_cacheName, _customPosition];
        _customPosition;
    };
};

// Correct width and height factor
private _widthFactor = 0.5;
private _heightFactor = 0.8;

private _centerOfMass = getCenterOfMass _vehicle;
private _boundingBox = boundingBoxReal _vehicle;
private _backLeftCorner = _boundingBox select 0;
private _frontRightCorner = _boundingBox select 1;

_externalIntercomInset = [(_frontRightCorner select 0) * _widthFactor, _backLeftCorner select 1, ((_centerOfMass select 2) * _heightFactor)];
_externalIntercomPoint = lineIntersectsSurfaces [AGLToASL (_vehicle modelToWorld _externalIntercomInset), AGLToASL (_vehicle modelToWorld _centerOfMass)] select 0 select 0;

TRACE_1("Calculated Position set to: %1", _vehicle worldToModel ASLToAGL _externalIntercomPoint);
private _position = _vehicle worldToModel ASLToAGL _externalIntercomPoint;
EGVAR(core,VehicleConfigCacheNamespace) setVariable [_cacheName, _position];
_position;
