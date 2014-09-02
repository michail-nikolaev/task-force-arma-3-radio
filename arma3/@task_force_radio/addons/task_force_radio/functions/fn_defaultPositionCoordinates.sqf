/*
 	Name: TFAR_fnc_defaultPositionCoordinates
 	
 	Author(s):
		NKey

 	Description:
		Prepares the position coordinates of the passed unit.
	
	Parameters:
		0: OBJECT - unit
		1: BOOLEAN - Is near player
 	
 	Returns:
		Nothing
 	
 	Example:
		
*/
private ["_unit","_current_eyepos","_current_x","_current_y","_current_z","_current_look_at_x","_current_look_at_y","_current_look_at_z","_current_hyp_horizontal","_current_rotation_horizontal","_player_pos","_isolated_and_inside","_can_speak","_current_look_at", "_isNearPlayer", "_renderAt", "_pos", "_depth", "_useSw", "_useLr", "_useDd"];
_unit = _this select 0;
_isNearPlayer = _this select 1;
_current_eyepos = eyepos _unit;
_current_rotation_horizontal = 0;

if (_unit != player) then {
	if !(_isNearPlayer) then {
		_current_x = (_current_eyepos select 0);
		_current_y = (_current_eyepos select 1);
		_current_z = (_current_eyepos select 2);
	} else {
		_renderAt = visiblePosition _unit;
		_pos = getPos _unit;	
		// add different between pos and eyepos to visiblePosition to get some kind of visiblePositionEyepos
		_current_x =  (_renderAt select 0) + ((_current_eyepos select 0) - (_pos select 0));
		_current_y =  (_renderAt select 1) + ((_current_eyepos select 1) - (_pos select 1));
		_current_z =  (_renderAt select 2) + ((_current_eyepos select 2) - (_pos select 2));
	};

	// for now it used only for player
	_current_rotation_horizontal = 0;
	if (alive player) then {
		_player_pos = eyePos player;
		_current_x = _current_x - (_player_pos select 0);
		_current_y = _current_y - (_player_pos select 1);
		_current_z = _current_z - (_player_pos select 2);
	};
	
} else {
	_current_x = (_current_eyepos select 0);
	_current_y = (_current_eyepos select 1);
	_current_z = (_current_eyepos select 2);
	_current_look_at = screenToWorld [0.5,0.5];
	_current_look_at_x = (_current_look_at select 0) - _current_x;
	_current_look_at_y = (_current_look_at select 1) - _current_y;
	_current_look_at_z = (_current_look_at select 2) - _current_z;


	_current_rotation_horizontal = 0;
	_current_hyp_horizontal = sqrt(_current_look_at_x * _current_look_at_x + _current_look_at_y * _current_look_at_y);

	if (_current_hyp_horizontal > 0) then {

		if (_current_look_at_x < 0) then {
			_current_rotation_horizontal = round - acos(_current_look_at_y / _current_hyp_horizontal);
		}
		else
		{
			_current_rotation_horizontal = round acos(_current_look_at_y / _current_hyp_horizontal);
		};
	} else {
		_current_rotation_horizontal = 0;
	};
	while{_current_rotation_horizontal < 0} do {
		_current_rotation_horizontal = _current_rotation_horizontal + 360;
	};
	_current_x = 0.0;
	_current_y = 0.0;
	_current_z = 0.0;
};
[_current_x,_current_y,_current_z, _current_rotation_horizontal]