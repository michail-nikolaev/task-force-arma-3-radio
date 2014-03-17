private ["_sw_frequencies", "_sw_settings"];
_sw_settings = [0, 7, [], 0, nil];

_sw_frequencies = [];
for "_i" from 0 to TF_MAX_CHANNELS step 1 do {
	_sw_frequencies set [_i, (str (round (((random (TF_MAX_SW_FREQ - TF_MIN_SW_FREQ)) + TF_MIN_SW_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER))];
};
_sw_settings set [2, _sw_frequencies];

_sw_settings