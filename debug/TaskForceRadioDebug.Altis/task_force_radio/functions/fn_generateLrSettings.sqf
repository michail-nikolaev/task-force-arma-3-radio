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
<<<<<<< HEAD
		ARRAY: Settings [0: NUMBER - Active channel, 1: NUMBER - Volume, 2: ARRAY - Frequencies for channels, 3: NUMBER - Stereo setting, 4: STRING - Encryption code, 5: NUMBER - Additional active channel, 6: NUMBER - Additional active channel stereo mode, 7: NUMBER - Speaker mode]
=======
		ARRAY: Settings [0: NUMBER - Active channel, 1: NUMBER - Volume, 2: ARRAY - Frequencies for channels, 3: NUMBER - Stereo setting, 4: STRING - Encryption code, 5: NUMBER - Additional active channel, 6: NUMBER - Additional active channel stereo mode]
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Example:
		_settings = call TFAR_fnc_generateLrSettings;
*/
<<<<<<< HEAD
private ["_lr_frequencies", "_lr_settings", "_set", "_volume"];
_volume = 7;
if (isNumber (ConfigFile >> "task_force_radio_settings" >> "tf_default_radioVolume")) then {
	getNumber(ConfigFile >> "task_force_radio_settings" >> "tf_default_radioVolume")
};

_lr_settings = [0, _volume, [], 0, nil, -1, 0, false];
_set = false;
_lr_frequencies = [];
if (typename _this == "BOOLEAN") then {
	if (!_this) then {
=======
private ["_lr_frequencies", "_lr_settings", "_set"];
_lr_settings = [0, 7, [], 0, nil, -1, 0];
_set = false;
_lr_frequencies = [];
if (typename _this == "BOOLEAN") then
{
	if (!_this) then
	{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
		for "_i" from 0 to TF_MAX_LR_CHANNELS step 1 do {
			_lr_frequencies set [_i, "50"];
		};
		_set = true;
	};
};
<<<<<<< HEAD
if (!_set) then {
=======
if (!_set) then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	_lr_frequencies = [TF_MAX_LR_CHANNELS,TF_MAX_ASIP_FREQ,TF_MIN_ASIP_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};
_lr_settings set [2, _lr_frequencies];

_lr_settings