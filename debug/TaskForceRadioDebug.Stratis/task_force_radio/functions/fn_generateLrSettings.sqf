private ["_lr_frequencies"];
_lr_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
for "_i" from FREQ_OFFSET to (FREQ_OFFSET + MAX_LR_CHANNELS) step 1 do {
	_lr_frequencies set [_i, (str (round (((random (MAX_ASIP_FREQ - MIN_ASIP_FREQ)) + MIN_ASIP_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
};
_lr_frequencies