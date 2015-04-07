/*
 	Name: TFAR_fnc_currentDirection
 	
 	Author(s):
		NKey	
 	
 	Description:
		Returns current direction of players head.
 	
 	Parameters: 
		Nothing
 	
 	Returns:
		0: NUMBER: head direction azimuth
 	
 	Example:
		call TFAR_fnc_currentDirection
*/
private ["_current_look_at_x","_current_look_at_y","_current_look_at_z","_current_hyp_horizontal","_current_rotation_horizontal"];

_current_look_at = (screenToWorld [0.5,0.5]) vectorDiff (eyepos TFAR_currentUnit);
_current_look_at_x = _current_look_at select 0;
_current_look_at_y = _current_look_at select 1;
_current_look_at_z = _current_look_at select 2;

_current_rotation_horizontal = 0;
_current_hyp_horizontal = sqrt(_current_look_at_x * _current_look_at_x + _current_look_at_y * _current_look_at_y);

if (_current_hyp_horizontal > 0) then {
	if (_current_look_at_x < 0) then {
		_current_rotation_horizontal = round - acos(_current_look_at_y / _current_hyp_horizontal);
	}else{
		_current_rotation_horizontal = round acos(_current_look_at_y / _current_hyp_horizontal);
	};
} else {
	_current_rotation_horizontal = 0;
};
while{_current_rotation_horizontal < 0} do {
	_current_rotation_horizontal = _current_rotation_horizontal + 360;
};
_current_rotation_horizontal;