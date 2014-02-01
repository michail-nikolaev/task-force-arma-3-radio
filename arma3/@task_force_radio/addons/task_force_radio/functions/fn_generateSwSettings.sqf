private ["_sw_frequencies"];	
_sw_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
for "_i" from TF_FREQ_OFFSET to (TF_FREQ_OFFSET + TF_MAX_CHANNELS) step 1 do {
	_sw_frequencies set [_i, (str (round (((random (TF_MAX_SW_FREQ - TF_MIN_SW_FREQ)) + TF_MIN_SW_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER))];
};	
_sw_frequencies