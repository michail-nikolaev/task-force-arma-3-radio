/*
 	Name: TFAR_fnc_initialiseFreqModule

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
private ["_logic", "_activated", "_units"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_units = [_this,1,[],[[]]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then {
	if (count _units == 0) exitWith { hint "TFAR - No units set for Frequency Module";diag_log "TFAR - No units set for Frequency Module";};
	if (isServer) then {
		private ["_swFreq", "_lrFreq", "_freqTest", "_freqs", "_randomFreqs"];
		
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
		while {count _freqs < TF_MAX_LR_CHANNELS} do{
			_freqs set [count _freqs, _randomFreqs select (count _freqs)];
		};
		_lrFreq set [2,_freqs];
		
		{
			_freqTest = (group _x) getVariable "tf_sw_frequency";
			if (!isNil "_freqTest") then {hint format["TFAR - tf_sw_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];diag_log format["TFAR - tf_sw_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];};
			
			_freqTest = (group _x) getVariable "tf_lr_frequency";
			if (!isNil "_freqTest") then {hint format["TFAR - tf_lr_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];diag_log format["TFAR - tf_lr_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];};
			
			(group _x) setVariable ["tf_sw_frequency", _swFreq, true];
			(group _x) setVariable ["tf_lr_frequency", _lrFreq, true];
		} count _units;
	};
};

true