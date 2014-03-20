private ["_isolated_and_inside", "_depth"];

_depth = _this select 0;
_isolated_and_inside = _this select 1;

(_depth < 0) and !(_isolated_and_inside)