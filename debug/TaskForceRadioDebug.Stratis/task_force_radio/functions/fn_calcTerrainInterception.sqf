private ["_result", "_steps", "_p1", "_p2", "_middle"];
_result = 0;
_steps = [50, 75, 100, 125, 150, 200, 250, 300, 500];
_p1 = eyePos player;
_p2 = eyePos _this;
if (terrainIntersectASL[_p1, _p2]) then {
	_result = 1600;
	_middle = [((_p1 select 0) + (_p2 select 0)) / 2.0, ((_p1 select 1) + (_p2 select 1)) / 2.0, ((_p1 select 2) + (_p2 select 2)) / 2.0];
	{
		_middle set[2, (_middle select 2) + _x];
		if ((!terrainIntersectASL [ _p1, _middle ]) and {!terrainIntersectASL [ _p2, _middle ]}) exitWith {_result = _x};
	} count _steps;
};
_result