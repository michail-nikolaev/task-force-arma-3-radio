private ["_player", "_isolated_and_inside", "_result", "_depth"];

_depth = _this select 2;
_result = false;

if (_depth > 0) then {
	_result = true;
} else {
	_player = _this select 0;
	_isolated_and_inside = _this select 1;
	if ((vehicle _player != _player) and {_depth > -3}) then {
		if ((_isolated_and_inside) or {isAbleToBreathe _player}) then {
			_result = true;
		};
	};
};

_result