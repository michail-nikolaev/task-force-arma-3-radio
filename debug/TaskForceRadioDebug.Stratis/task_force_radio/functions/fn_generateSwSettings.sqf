private ["_sw_frequencies"];	
_sw_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
for "_i" from FREQ_OFFSET to (FREQ_OFFSET + MAX_CHANNELS) step 1 do {
	_sw_frequencies set [_i, (str (round (((random (MAX_SW_FREQ - MIN_SW_FREQ)) + MIN_SW_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
};	
_sw_frequencies