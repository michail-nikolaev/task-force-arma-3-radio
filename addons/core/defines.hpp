#define SW_EDIT 1400
#define SW_CHANNEL 1604
#define ID_ADDITIONAL 12345
#define ID_SPEAKERS 123456
#define LR_EDIT 1410
#define LR_CHANNEL 1411

#define SHIFTL 42
#define CTRLL 29
#define ALTL 56
#define ACTIVE_CHANNEL_OFFSET 0
#define VOLUME_OFFSET 1
#define RADIO_OWNER 7
#define SPEAKER_OFFSET 8
#define POWER_OFFSET 9

#define MAX_RADIO_COUNT 1000

#define TFAR_FREQ_OFFSET 2
#define TFAR_FREQ_ROUND_POWER 10//#TODO https://community.bistudio.com/wiki/toFixed after 1.65 release
//round (_f * TFAR_FREQ_ROUND_POWER) / TFAR_FREQ_ROUND_POWER    -> _f toFixed 1
//or use CBA_fnc_formatNumber
// str (round (_f * TFAR_FREQ_ROUND_POWER) / TFAR_FREQ_ROUND_POWER))   ->>>> _f toFixed 1
//#define ROUND_FREQ(FREQUENCY) FREQUENCY toFixes 1

#define TFAR_MAX_CHANNELS 8
#define TFAR_MIN_SW_FREQ 30
#define TFAR_MAX_SW_FREQ 512

#define TFAR_MAX_LR_CHANNELS 9

#define TFAR_MIN_ASIP_FREQ 30
#define TFAR_MAX_ASIP_FREQ 87

#define TFAR_SW_STEREO_OFFSET (TFAR_FREQ_OFFSET + 1)
#define TFAR_LR_STEREO_OFFSET (TFAR_FREQ_OFFSET + 1)
#define TFAR_MAX_STEREO 3

#define TFAR_CODE_OFFSET (TFAR_SW_STEREO_OFFSET + 1)
#define TFAR_ADDITIONAL_CHANNEL_OFFSET (TFAR_CODE_OFFSET + 1)
#define TFAR_ADDITIONAL_STEREO_OFFSET (TFAR_ADDITIONAL_CHANNEL_OFFSET + 1)

#define TFAR_LR_SPEAKER_OFFSET 8
#define TFAR_SW_SPEAKER_OFFSET 8


#define TFAR_PLAYER_RESCAN_TIME 1//Interval between Rescans of Players

#define TFAR_FAR_PLAYER_UPDATE_TIME 3.5 //Interval between updates of Far(>TF_max_voice_volume) Player positions

#define TFAR_VOLUME_WHISPERING  5
#define TFAR_VOLUME_NORMAL      20
#define TFAR_VOLUME_YELLING     60
