FREQ_OFFSET = 2;
FREQ_ROUND_POWER = 10;

MAX_CHANNELS = 8;
MIN_SW_FREQ = 30;
MAX_SW_FREQ = 512;

MAX_LR_CHANNELS = 9;

MIN_ASIP_FREQ = 30;
MAX_ASIP_FREQ = 87;

SW_STEREO_OFFSET = FREQ_OFFSET + MAX_CHANNELS + 1;
LR_STEREO_OFFSET = FREQ_OFFSET + MAX_LR_CHANNELS + 1;
MAX_STEREO = 3;


generateSwSetting = 
{
	private ["_sw_frequencies"];	
	_sw_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	for "_i" from FREQ_OFFSET to (FREQ_OFFSET + MAX_CHANNELS) step 1 do {
		_sw_frequencies set [_i, (str (round (((random (MAX_SW_FREQ - MIN_SW_FREQ)) + MIN_SW_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
	};	
	_sw_frequencies;
};

generateLrSettings = 
{
	private ["_lr_frequencies"];
	_lr_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	for "_i" from FREQ_OFFSET to (FREQ_OFFSET + MAX_LR_CHANNELS) step 1 do {
		_lr_frequencies set [_i, (str (round (((random (MAX_ASIP_FREQ - MIN_ASIP_FREQ)) + MIN_ASIP_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
	};
	_lr_frequencies;
};