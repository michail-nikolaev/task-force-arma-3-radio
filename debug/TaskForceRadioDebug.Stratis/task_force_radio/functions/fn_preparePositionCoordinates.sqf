private ["_x_player","_current_eyepos","_x_playername","_current_x","_current_y","_current_z","_current_look_at_x","_current_look_at_y","_current_look_at_z","_current_hyp_horizontal","_current_rotation_horizontal","_player_pos","_isolated_and_inside","_can_speak","_current_look_at"];
_x_player = _this;
_current_eyepos = eyepos _x_player;
_x_playername = name _x_player;

_current_x = (_current_eyepos select 0);
_current_y = (_current_eyepos select 1);
_current_z = (_current_eyepos select 2);

_current_look_at = screenToWorld [0.5,0.5];
_current_look_at_x = (_current_look_at select 0) - _current_x;
_current_look_at_y = (_current_look_at select 1) - _current_y;
_current_look_at_z = (_current_look_at select 2) - _current_z;

_isolated_and_inside = _x_player call TFAR_fnc_vehicleIsIsolatedAndInside;

_current_rotation_horizontal = 0;
_current_hyp_horizontal = sqrt(_current_look_at_x * _current_look_at_x + _current_look_at_y * _current_look_at_y);

if (_current_hyp_horizontal > 0) then {

	if (_current_look_at_x < 0) then {
		_current_rotation_horizontal = round -acos(_current_look_at_y / _current_hyp_horizontal);
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
if (alive player) then 
{
	_player_pos = eyepos player;
	_current_x = _current_x - (_player_pos select 0);
	_current_y = _current_y - (_player_pos select 1);
	_current_z = _current_z - (_player_pos select 2);
};
_can_speak = [_x_player, _isolated_and_inside] call TFAR_fnc_canSpeak;
(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11", _x_playername, _current_x, _current_y, _current_z, _current_rotation_horizontal, _can_speak, [_x_player, _isolated_and_inside, _can_speak] call TFAR_fnc_canUseSWRadio, [_x_player, _isolated_and_inside] call TFAR_fnc_canUseLRRadio, [_x_player, _isolated_and_inside] call TFAR_fnc_canUseDDRadio,  _x_player call TFAR_fnc_vehicleId, _x_player call TFAR_fnc_calcTerrainInterception])