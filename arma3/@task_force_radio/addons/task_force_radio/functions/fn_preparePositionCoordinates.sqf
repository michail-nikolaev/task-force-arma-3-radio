/*
 	Name: TFAR_fnc_preparePositionCoordinates
 	
 	Author(s):
		NKey

 	Description:
		Prepares the position coordinates of the passed unit.
	
	Parameters:
		0: OBJECT - unit
<<<<<<< HEAD
		1: BOOLEAN - Is near player		
		3: STRING - Unit name
=======
		1: BOOLEAN - Is near player
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Returns:
		Nothing
 	
 	Example:
		
*/
<<<<<<< HEAD
private ["_x_player","_isolated_and_inside","_can_speak", "_pos", "_depth", "_useSw", "_useLr", "_useDd", "_freq", "_vehicle", "_radio_id"];
_unit = _this select 0;
_nearPlayer = _this select 1;

_pos = [_unit, _nearPlayer] call (_unit getVariable ["TF_fnc_position", TFAR_fnc_defaultPositionCoordinates]);
_isolated_and_inside = _unit call TFAR_fnc_vehicleIsIsolatedAndInside;
_depth = _unit call TFAR_fnc_eyeDepth;
=======
private ["_x_player","_current_eyepos","_current_x","_current_y","_current_z","_current_look_at_x","_current_look_at_y","_current_look_at_z","_current_hyp_horizontal","_current_rotation_horizontal","_player_pos","_isolated_and_inside","_can_speak","_current_look_at", "_isNearPlayer", "_renderAt", "_pos", "_depth", "_useSw", "_useLr", "_useDd"];
_x_player = _this select 0;
_isNearPlayer = _this select 1;
_current_eyepos = eyepos _x_player;


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

	// for now it used only for player
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
	_current_x = 0.0;
	_current_y = 0.0;
	_current_z = 0.0;
};

_isolated_and_inside = _x_player call TFAR_fnc_vehicleIsIsolatedAndInside;

_depth = _player call TFAR_fnc_eyeDepth;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
_can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
_useSw = true;
_useLr = true;
_useDd = false;
if (_depth < 0) then {
<<<<<<< HEAD
	_useSw = [_unit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio;
	_useLr = [_unit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio;	
	_useDd = [_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio;
};
if (count _pos != 4) then {
	_pos pushBack 0;
};

_vehicle = _unit call TFAR_fnc_vehicleId;
if ((_nearPlayer) and {TFAR_currentUnit distance _unit <= TF_speakerDistance}) then {	
	if (_unit getVariable ["tf_lr_speakers", false] && _useLr) then {
		{
			if (_x call TFAR_fnc_getLrSpeakers) then {
				_freq = format ["%1%2", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode];
				if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
					_freq = _freq + format ["|%1%2", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode];
				};
				_radio_id = netId (_x select 0);
				if (_radio_id == '') then {
					_radio_id = str (_x select 0);
				};

				tf_speakerRadios pushBack (format ["%1%2%3%4%5%6%7%8%9%10%11%12%13", _radio_id, TF_new_line, _freq, TF_new_line, _this select 2, TF_new_line, [], TF_new_line, _x call TFAR_fnc_getLrVolume, TF_new_line, _vehicle, TF_new_line, (getPosASL _unit) select 2]);
			};
			true;
		} count (_unit call TFAR_fnc_lrRadiosList);
	};
	
	if (_unit getVariable ["tf_sw_speakers", false] && _useSw) then {
		{
			if (_x call TFAR_fnc_getSwSpeakers) then {
				_freq = format ["%1%2", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode];
				if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
					_freq = _freq + format ["|%1%2", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode];
				};
				_radio_id = _x;		
				tf_speakerRadios pushBack (format ["%1%2%3%4%5%6%7%8%9%10%11%12%13", _radio_id, TF_new_line, _freq, TF_new_line, _this select 2, TF_new_line, [], TF_new_line, _x call TFAR_fnc_getSwVolume, TF_new_line, _vehicle, TF_new_line, (getPosASL _unit) select 2]);
			};
			true;
		} count (_unit call TFAR_fnc_radiosList);
	};	
};

(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13", _this select 2, _pos select 0, _pos select 1, _pos select 2, _pos select 3, _can_speak, _useSw, _useLr, _useDd, _vehicle, _unit call TFAR_fnc_calcTerrainInterception, _unit getVariable ["tf_voiceVolume", 1.0], call TFAR_fnc_currentDirection])
=======
	_useSw = [_x_player, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio;
	_useLr = [_x_player, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio;	
	_useDd = [_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio;
};

(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11", name _x_player, _current_x, _current_y, _current_z, _current_rotation_horizontal, _can_speak, _useSw, _useLr, _useDd,  _x_player call TFAR_fnc_vehicleId, _x_player call TFAR_fnc_calcTerrainInterception])
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
