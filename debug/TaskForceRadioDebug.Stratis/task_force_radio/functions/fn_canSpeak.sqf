private ["_result", "_player", "_isolated_and_inside"];

_result = false;
_player = _this select 0;
_isolated_and_inside = _this select 1;

if ((_player call TFAR_fnc_eyeDepth) > 0) then {
	_result = true;
} else {
	_result = _isolated_and_inside;
};
_result