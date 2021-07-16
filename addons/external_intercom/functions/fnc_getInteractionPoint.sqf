params ["_vehicle"];

private _customPosition = getArray((configOf _vehicle) >> "TFAR_ExternalIntercomInteractionPoint");

// If there's a custom position, then don't bother calculating
if !(_customPosition isEqualTo []) exitWith {
   _customPosition;
};

// Correct width and height factor
private _widthFactor = 0.6;
private _heightFactor = 0.8;

private _centerOfMass = getCenterOfMass _vehicle;
private _bbr = boundingBoxReal _vehicle;
private _p1 = _bbr select 0;
private _p2 = _bbr select 1;
private _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
private _widthOffset = ((_maxWidth / 2) - abs ( _centerOfMass select 0 )) * _widthFactor;
private _heightOffset = (_centerOfMass select 2) * _heightFactor;
private _rearCorner = [(_centerOfMass select 0) + _widthOffset, _p1 select 1, _heightOffset];
private _rearCorner2 = [(_centerOfMass select 0) - _widthOffset, _p1 select 1, _heightOffset];

_externalIntercomInset = ((_rearCorner vectorDiff _rearCorner2) vectorMultiply 0.8) vectorAdd  _rearCorner2;
_externalIntercomPoint = lineIntersectsSurfaces [AGLToASL (_vehicle modelToWorld _externalIntercomInset), AGLToASL (_vehicle modelToWorld _centerOfMass)] select 0 select 0;

ASLToAGL (_vehicle worldToModel _externalIntercomPoint);
