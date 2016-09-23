/*
 	Name: TFAR_fnc_preparePositionCoordinates
 	
 	Author(s):
		NKey

 	Description:
		Prepares the position coordinates of the passed unit.
	
	Parameters:
		0: OBJECT - unit
		1: BOOLEAN - Is near player		
		3: STRING - Unit name
 	
 	Returns:
		Nothing
 	
 	Example:
		
*/
private ["_x_player","_isolated_and_inside","_can_speak", "_pos", "_depth", "_useSw", "_useLr", "_useDd", "_freq", "_vehicle", "_radio_id"];
_unit = _this select 0;
_nearPlayer = _this select 1;

_pos = [_unit, _nearPlayer] call (_unit getVariable ["TF_fnc_position", TFAR_fnc_defaultPositionCoordinates]);
_isolated_and_inside = _unit call TFAR_fnc_vehicleIsIsolatedAndInside;
_depth = _unit call TFAR_fnc_eyeDepth;
_can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
_useSw = true;
_useLr = true;
_useDd = false;
if (_depth < 0) then {
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