/*
 	Name: TFAR_fnc_initialiseBaseModule
 	
 	Author(s):
		L-H
 	
 	Description:
		Initialises variables based on module settings.
 	
 	Parameters:
 	
 	Returns:
		Nothing
 	
 	Example:
	
 */
#include "common.sqf"
private ["_logic", "_activated"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_units = [_this,1,[],[[]]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then {
	private ["_LRradio","_radio", "_currentSide", "_swFreq", "_lrFreq", "_freqs","_randomFreqs"];
	
	_swFreq = false call TFAR_fnc_generateSwSettings;
	_freqs = call compile (_logic getVariable "PrFreq");
	_randomFreqs = [TF_MAX_CHANNELS,TF_MAX_SW_FREQ,TF_MIN_SW_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
	while {count _freqs < TF_MAX_CHANNELS} do {
		_freqs set [count _freqs, _randomFreqs select (count _freqs)];
	};
	_swFreq set [2,_freqs];
	
	_lrFreq = false call TFAR_fnc_generateLrSettings;
	_freqs = call compile (_logic getVariable "LrFreq");
	_randomFreqs = [TF_MAX_LR_CHANNELS,TF_MAX_ASIP_FREQ,TF_MIN_ASIP_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
	while {count _freqs < TF_MAX_LR_CHANNELS} do {
		_freqs set [count _freqs, _randomFreqs select (count _freqs)];
	};
	_lrFreq set [2,_freqs];
	
	_LRradio = _logic getVariable "LRradio";
	_radio = _logic getVariable "Radio";
	_currentSide = "North";
	
	tf_same_sw_frequencies_for_side = true;
	tf_same_lr_frequencies_for_side = true;
	
	_RiflemanRadio = _logic getVariable "RiflemanRadio";
	_radio_code = _logic getVariable "Encryption";
	if (([_LRradio, "tf_hasLrRadio",0] call TFAR_fnc_getConfigProperty) != 0) then {
		diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
		hint format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
		_LRradio = "-1";
	};
	if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") != 1) then {
		diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
		_radio = "-1";
	};
	{
		if ((str _currentSide) != (str side _x)) then {
			_currentSide = side _x;
			if (_currentSide == independent || {_currentSide == civilian}) then {
				_currentSide = "guer";
			};
		
			missionNamespace setVariable [format ["TF_default%1RiflemanRadio", _currentSide], _RiflemanRadio];
			missionNamespace setVariable [format ["TF_%1_radio_code", _currentSide], _radio_code];
			if (_LRradio != "-1") then {
				missionNamespace setVariable [format ["TF_default%1Backpack", _currentSide], _LRradio];
			};
			if (_radio != "-1") then {
				missionNamespace setVariable [format ["TF_default%1PersonalRadio", _currentSide], _radio];
			};
			
			if (isServer) then {
				if (!isNil (format ["tf_freq_%1", _currentSide])) then {hint "TFAR - tf_freq_west already set, module overriding.";diag_log "TFAR - tf_freq_west already set, module overriding.";};
				if (!isNil (format ["tf_freq_%1_lr", _currentSide])) then {hint "TFAR - tf_freq_west_lr already set, module overriding.";diag_log "TFAR - tf_freq_west_lr already set, module overriding.";};
				missionNamespace setVariable [format ["tf_freq_%1", _currentSide], _swFreq];
				missionNamespace setVariable [format ["tf_freq_%1_lr", _currentSide], _lrFreq];
			};
		};
	} count _units;
};

true