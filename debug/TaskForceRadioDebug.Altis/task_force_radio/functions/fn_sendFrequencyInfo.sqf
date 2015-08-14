/*
 	Name: TFAR_fnc_sendFrequencyInfo
 	
 	Author(s):
		NKey

 	Description:
		Notifies the plugin about the radios currently being used by the player and various settings active on the radio.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_sendFrequencyInfo;
*/

private ["_request","_result","_freq","_freq_lr","_freq_dd","_alive","_nickname","_isolated_and_inside","_can_speak","_depth","_globalVolume", "_voiceVolume", "_spectator", "_receivingDistanceMultiplicator", "_radios"];

// send frequencies
_freq = ["No_SW_Radio"];
_freq_lr = ["No_LR_Radio"];
_freq_dd = "No_DD_Radio";

_isolated_and_inside = TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside;
_depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
_can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;

if (((call TFAR_fnc_haveSWRadio) or (TFAR_currentUnit != player)) and {[TFAR_currentUnit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio}) then {
	_freq = [];	
	_radios = TFAR_currentUnit call TFAR_fnc_radiosList;
	if (TFAR_currentUnit != player) then {
		_radios = _radios + (player call TFAR_fnc_radiosList);
	};
	{
		if (!(_x call TFAR_fnc_getSwSpeakers) or {(TFAR_currentUnit != player) and (_x in (player call TFAR_fnc_radiosList))}) then {
			if ((_x call TFAR_fnc_getAdditionalSwChannel) == (_x call TFAR_fnc_getSwChannel)) then {
				_freq pushBack format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getAdditionalSwStereo];
			} else {
				_freq pushBack format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getSwStereo];
				if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
					_freq pushBack format ["%1%2|%3|%4", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getAdditionalSwStereo];
				};
			};
		};		
		true;
	} count (_radios);
};
if (((call TFAR_fnc_haveLRRadio) or (TFAR_currentUnit != player)) and {[TFAR_currentUnit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio}) then {
	_freq_lr = [];
	_radios = TFAR_currentUnit call TFAR_fnc_lrRadiosList;
	if (TFAR_currentUnit != player) then {
		_radios = _radios + (player call TFAR_fnc_lrRadiosList);
	};
	{
		if (!(_x call TFAR_fnc_getLrSpeakers) or {(TFAR_currentUnit != player) and (_x in (player call TFAR_fnc_lrRadiosList))}) then {
			if ((_x call TFAR_fnc_getAdditionalLrChannel) == (_x call TFAR_fnc_getLrChannel)) then {
				_freq_lr pushBack format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getAdditionalLrStereo];
			} else {
				_freq_lr pushBack format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getLrStereo];
				if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
					_freq_lr pushBack format ["%1%2|%3|%4", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getAdditionalLrStereo];
				};
			};
		};
		true;
	} count (_radios);
};
if ((call TFAR_fnc_haveDDRadio) and {[_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio}) then {
	_freq_dd = TF_dd_frequency;
};
_alive = alive TFAR_currentUnit;
if (_alive) then {
	TFAR_player_name = name player;
};

_nickname = TFAR_player_name;
_globalVolume = TFAR_currentUnit getVariable "tf_globalVolume";
if (isNil "_globalVolume") then {
	_globalVolume = 1.0;
};
_voiceVolume = TFAR_currentUnit getVariable "tf_voiceVolume";
if (isNil "_voiceVolume") then {
	_voiceVolume = 1.0;
};
_spectator = TFAR_currentUnit getVariable "tf_forceSpectator";
if (isNil "_spectator") then {
	_spectator = false;
};
if (_spectator) then {
	_alive = false;
};
_receivingDistanceMultiplicator = TFAR_currentUnit getVariable "tf_receivingDistanceMultiplicator";
if (isNil "_receivingDistanceMultiplicator") then {
	_receivingDistanceMultiplicator = 1.0;
};

_request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13", str(_freq), str(_freq_lr), _freq_dd, _alive, TF_speak_volume_meters min TF_max_voice_volume, TF_dd_volume_level, _nickname, waves, TF_terrain_interception_coefficient, _globalVolume, _voiceVolume, _receivingDistanceMultiplicator, TF_speakerDistance];
_result = "task_force_radio_pipe" callExtension _request;