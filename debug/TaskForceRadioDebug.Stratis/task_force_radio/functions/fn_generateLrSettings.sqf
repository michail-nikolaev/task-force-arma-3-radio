private ["_lr_frequencies"];
_lr_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
for "_i" from TF_FREQ_OFFSET to (TF_FREQ_OFFSET + TF_MAX_LR_CHANNELS) step 1 do {
	_lr_frequencies set [_i, (str (round (((random (TF_MAX_ASIP_FREQ - TF_MIN_ASIP_FREQ)) + TF_MIN_ASIP_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER))];
};
_lr_frequencies