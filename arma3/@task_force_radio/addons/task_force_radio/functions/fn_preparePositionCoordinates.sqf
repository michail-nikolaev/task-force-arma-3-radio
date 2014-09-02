/*
 	Name: TFAR_fnc_preparePositionCoordinates
 	
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
private ["_x_player","_current_eyepos","_current_x","_current_y","_current_z","_current_look_at_x","_current_look_at_y","_current_look_at_z","_current_hyp_horizontal","_current_rotation_horizontal","_player_pos","_isolated_and_inside","_can_speak","_current_look_at", "_isNearPlayer", "_renderAt", "_pos", "_depth", "_useSw", "_useLr", "_useDd"];
_x_player = _this select 0;
_isNearPlayer = _this select 1;
_current_eyepos = eyePos _x_player;

if (_x_player != player) then {
	if (_isNearPlayer) then {
		// This portion of the code appears that it will be extremely slow
		// It makes use of the 2 slower position functions.
		_renderAt = visiblePosition _x_player;
		_pos = getPos _x_player;
		// add different between pos and eyepos to visiblePosition to get some kind of visiblePositionEyepos
		_current_eyepos = _renderAt vectorAdd (_current_eyepos vectorDiff _pos);
	};

	// for now it used only for player
	_current_rotation_horizontal = 0;
	if (alive player) then {
		_current_eyepos = _current_eyepos vectorDiff (eyePos player);
	};
} else {
	_current_look_at = (screenToWorld [0.5,0.5]) vectorDiff _current_eyePos;
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
	_current_eyepos = [0,0,0];
};

_isolated_and_inside = _x_player call TFAR_fnc_vehicleIsIsolatedAndInside;

_depth = _player call TFAR_fnc_eyeDepth;
_can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
_useSw = true;
_useLr = true;
_useDd = false;
if (_depth < 0) then {
	_useSw = [_x_player, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio;
	_useLr = [_x_player, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio;	
	_useDd = [_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio;
};

(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11", name _x_player, _current_eyepos select 0, _current_eyepos select 1, _current_eyepos select 2, _current_rotation_horizontal, _can_speak, _useSw, _useLr, _useDd,  _x_player call TFAR_fnc_vehicleId, _x_player call TFAR_fnc_calcTerrainInterception])