/*
 	Name: TFAR_fnc_generateFrequencies
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Generates frequencies based on the passed parameters to be used in radio settings.
	
	Parameters:
		0: NUMBER - Channels
		1: NUMBER - Max frequency
		2: NUMBER - Min frequency
		3: NUMBER - Frequency Round Power
 	
 	Returns:
		ARRAY: Frequencies for channels
 	
 	Example:
		// LR
		_frequencies = [TF_MAX_LR_CHANNELS,TF_MAX_ASIP_FREQ,TF_MIN_ASIP_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
		// SW
		_sw_frequencies = [TF_MAX_CHANNELS,TF_MAX_SW_FREQ,TF_MIN_SW_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
*/
private ["_frequencies"];
_frequencies = [];

for "_i" from 0 to (_this select 0) step 1 do {
	_frequencies set [_i, (str (round (((random ((_this select 1) - (_this select 2))) + (_this select 2)) * (_this select 3)) / (_this select 3)))];
};

_frequencies