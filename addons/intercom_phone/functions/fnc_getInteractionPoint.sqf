params ["_vehicle"];

private _customPosition = getArray(configOf _vehicle);

// If there's a custom position, then don't bother calculating
if !(_customPosition isEqualTo []) exitWith {
   _customPosition;
};

private [
   "_centerOfMass","_bbr","_p1","_p2","_rearCorner","_rearCorner2","_maxWidth",
   "_widthOffset","_widthFactor",
   "_heightOffset","_intercomPhoneInset","_intercomPhonePoint"
];

// Correct width and height factor
_widthFactor = 0.6;
_heightFactor = 0.8;

_centerOfMass = getCenterOfMass _vehicle;
_bbr = boundingBoxReal _vehicle;
_p1 = _bbr select 0;
_p2 = _bbr select 1;
_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
_widthOffset = ((_maxWidth / 2) - abs ( _centerOfMass select 0 )) * _widthFactor;
_heightOffset = (_centerOfMass select 2) * _heightFactor;
_rearCorner = [(_centerOfMass select 0) + _widthOffset, _p1 select 1, _heightOffset];
_rearCorner2 = [(_centerOfMass select 0) - _widthOffset, _p1 select 1, _heightOffset];

_intercomPhoneInset = ((_rearCorner vectorDiff _rearCorner2) vectorMultiply 0.8) vectorAdd  _rearCorner2;
_intercomPhonePoint = lineIntersectsSurfaces [AGLToASL (_vehicle modelToWorld _intercomPhoneInset), AGLToASL (_vehicle modelToWorld _centerOfMass)] select 0 select 0;

ASLToAGL (_vehicle worldToModel _intercomPhonePoint);
