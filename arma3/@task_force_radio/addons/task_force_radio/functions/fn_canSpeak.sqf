/*
 	Name: TFAR_fnc_canSpeak
 	
 	Author(s):
		NKey

 	Description:
		Tests whether it would be possible to speak at the given eye height and whether the unit is within an isolated vehicle.
	
	Parameters:
		0: BOOLEAN - Whether the unit is isolated and inside a vehicle.
		1: NUMBER - The eye depth.
 	
 	Returns:
		BOOLEAN - Whether it is possible to speak.
 	
 	Example:
		_canSpeak = [false, -12] call TFAR_fnc_canSpeak;
*/
private ["_result"];

_result = false;

if ((_this select 1) > 0) then {
	_result = true;
} else {
	_result = _this select 0;
};
_result