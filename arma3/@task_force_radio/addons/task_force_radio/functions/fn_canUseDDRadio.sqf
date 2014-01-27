private ["_player", "_isolated_and_inside"];

_player = _this select 0;
_isolated_and_inside = _this select 1;

((_player call eyeDepth) < 0) and !(_isolated_and_inside)