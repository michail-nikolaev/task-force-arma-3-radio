/*
 	Name: TFAR_fnc_generateLrSettings
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Generates settings for the LR radio
	
	Parameters:
		OPTIONAL: BOOLEAN - false to generate settings without generating frequencies.
 	
 	Returns:
		ARRAY: Settings [0: NUMBER - Active channel, 1: NUMBER - Volume, 2: ARRAY - Frequencies for channels, 3: NUMBER - Stereo setting, 4: STRING - Encryption code, 5: NUMBER - Additional active channel, 6: NUMBER - Additional active channel stereo mode]
 	
 	Example:
		_settings = call TFAR_fnc_generateLrSettings;
*/
private ["_lr_frequencies", "_lr_settings", "_set", "_volume"];
_volume = 7;
if (isNumber (ConfigFile >> "task_force_radio_settings" >> "tf_default_radioVolume")) then {
	getNumber(ConfigFile >> "task_force_radio_settings" >> "tf_default_radioVolume")
};

_lr_settings = [0, _volume, [], 0, nil, -1, 0];
_set = false;
_lr_frequencies = [];
if (typename _this == "BOOLEAN") then {
	if (!_this) then {
		for "_i" from 0 to TF_MAX_LR_CHANNELS step 1 do {
			_lr_frequencies set [_i, "50"];
		};
		_set = true;
	};
};
if (!_set) then {
	_lr_frequencies = [TF_MAX_LR_CHANNELS,TF_MAX_ASIP_FREQ,TF_MIN_ASIP_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};
_lr_settings set [2, _lr_frequencies];

_lr_settings