/*
 	Name: TFAR_fnc_generateSwSettings
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Generates settings for the SW radio
	
	Parameters:
		Nothing
 	
 	Returns:
		ARRAY: Settings
			0: NUMBER - Active channel
			1: NUMBER - Volume
			2: ARRAY - Frequencies for channels
			3: NUMBER - Stereo setting
			4: STRING - Encryption code
			5: NUMBER - Additional active channel			
			6: NUMBER - Additional active channel stereo mode
 	
 	Example:
		_settings = call TFAR_fnc_generateSwSettings;
*/
private ["_sw_frequencies", "_sw_settings"];
_sw_settings = [0, 7, [], 0, nil, -1, 0];

_sw_frequencies = [];
for "_i" from 0 to TF_MAX_CHANNELS step 1 do {
	_sw_frequencies set [_i, (str (round (((random (TF_MAX_SW_FREQ - TF_MIN_SW_FREQ)) + TF_MIN_SW_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER))];
};
_sw_settings set [2, _sw_frequencies];

_sw_settings