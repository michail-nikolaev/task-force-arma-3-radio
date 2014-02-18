private ["_player","_result","_depth"];

_result = false;
_player = _this select 0;
_depth = _player call TFAR_fnc_eyeDepth;

if (_depth > 0) then {
	_result = true;
} else {
	if ((_this select 2) and {_depth > -1} and {vehicle _player != _player}) then {
		if ((_this select 1) or {isAbleToBreathe _player}) then {
			_result = true;
		};
	};
};
_result