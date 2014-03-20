private ["_x_player","_current_eyepos","_current_x","_current_y","_current_z","_current_look_at_x","_current_look_at_y","_current_look_at_z","_current_hyp_horizontal","_current_rotation_horizontal","_player_pos","_isolated_and_inside","_can_speak","_current_look_at", "_isNearPlayer", "_renderAt", "_pos", "_depth", "_useSw", "_useLr", "_useDd"];
_x_player = _this select 0;
_isNearPlayer = _this select 1;
_current_eyepos = eyepos _x_player;

// for now it used only for player
if (_x_player != player) then {
	
	if !(_isNearPlayer) then {
		_current_x = (_current_eyepos select 0);
		_current_y = (_current_eyepos select 1);
		_current_z = (_current_eyepos select 2);
	} else {
		_renderAt = visiblePosition _x_player;
		_pos = getPos _x_player;	
		// add different between pos and eyepos to visiblePosition to get some kind of visiblePositionEyepos
		_current_x =  (_renderAt select 0) + ((_current_eyepos select 0) - (_pos select 0));
		_current_y =  (_renderAt select 1) + ((_current_eyepos select 1) - (_pos select 1));
		_current_z =  (_renderAt select 2) + ((_current_eyepos select 2) - (_pos select 2));
	};

	_current_rotation_horizontal = 0;
	if (alive player) then 
	{
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

(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11", name _x_player, _current_x, _current_y, _current_z, _current_rotation_horizontal, _can_speak, _useSw, _useLr, _useDd,  _x_player call TFAR_fnc_vehicleId, _x_player call TFAR_fnc_calcTerrainInterception])