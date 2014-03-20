/* 
0 - _isolated_and_inside
1 - eye depth
*/
private ["_result"];

_result = false;

if ((_this select 1) > 0) then {
	_result = true;
} else {
	_result = _this select 0;
};
_result