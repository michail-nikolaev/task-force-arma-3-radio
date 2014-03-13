private ["_lr_frequencies", "_lr_settings"];
_lr_settings = [0, 7, [], 0, nil];

_lr_frequencies = [];
for "_i" from 0 to TF_MAX_LR_CHANNELS step 1 do {
	_lr_frequencies set [_i, (str (round (((random (TF_MAX_ASIP_FREQ - TF_MIN_ASIP_FREQ)) + TF_MIN_ASIP_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER))];
};
_lr_settings set [2, _lr_frequencies];

_lr_settings