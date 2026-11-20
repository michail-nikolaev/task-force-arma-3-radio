#ifndef TFAR_CORE_DEFINES_HPP
#define TFAR_CORE_DEFINES_HPP

#define SW_EDIT 1400
#define SW_CHANNEL 1604
#define ID_ADDITIONAL 12345
#define ID_SPEAKERS 123456
#define LR_EDIT 1410
#define LR_CHANNEL 1411

// Hooks shared by the edit and clear controls in the radio dialogs.
#define TFAR_FREQUENCY_EDIT_EVENTS_OFFSET(OFFSET) \
    tf_channelNameOffset = OFFSET; \
    onMouseButtonDown = QUOTE([_this select 0] call TFAR_fnc_editRadioDialogFrequency; false); \
    onSetFocus = QUOTE([_this select 0] call TFAR_fnc_editRadioDialogFrequency); \
    onKeyDown = QUOTE([_this select 0] call TFAR_fnc_editRadioDialogFrequency; false);
#define TFAR_FREQUENCY_EDIT_EVENTS() TFAR_FREQUENCY_EDIT_EVENTS_OFFSET(44)
#define TFAR_CLEAR_FREQUENCY(DISPLAY_IDD,EDIT_IDC) [ARR_2((findDisplay DISPLAY_IDD) displayCtrl EDIT_IDC,true)] call TFAR_fnc_editRadioDialogFrequency

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
// Tuning precision: 10 gives one decimal place, 100 gives two.
#define TFAR_FREQ_ROUND_POWER 10

#define TFAR_ROUND_FREQUENCYP(frequency,pwr) (round (frequency * pwr) / pwr)
#define QTFAR_ROUND_FREQUENCYP(frequency,pwr) (if (( (round(frequency*pwr)) mod pwr) == 0) then {frequency toFixed 0} else {frequency toFixed (log pwr)})

#define TFAR_ROUND_FREQUENCY(frequency) TFAR_ROUND_FREQUENCYP(frequency,TFAR_FREQ_ROUND_POWER)
#define QTFAR_ROUND_FREQUENCY(frequency) QTFAR_ROUND_FREQUENCYP(frequency,TFAR_FREQ_ROUND_POWER)

#define TFAR_FREQUENCYSTRING_TO_FREQNUMBER(frequency) parseNumber ( ((frequency) splitString ",.") joinString "." )

#define TFAR_MAX_CHANNELS 8
#define TFAR_VALID_NAME_RADIO(RADIO) (if ((RADIO) isEqualType "") then {(RADIO) isNotEqualTo ""} else { \
    (RADIO) isEqualTypeParams [objNull,""] && {!isNull ((RADIO) select 0)} && {((RADIO) select 1) isNotEqualTo ""} \
})
#define TFAR_MAX_CHANNEL_NAME_LENGTH 8
#define TFAR_MAX_FREQUENCY_NAMES 16
#define TFAR_FREQUENCY_NAMES_VAR(SIDE,IS_LR) \
    format ["TFAR_frequencyNames_%1_%2", ["sr","lr"] select (IS_LR), if ((SIDE) isEqualTo independent) then {"independent"} else {toLower str (SIDE)}]
#define TFAR_MIN_SW_FREQ 30
#define TFAR_MAX_SW_FREQ 512

#define TFAR_MAX_LR_CHANNELS 9

#define TFAR_MIN_ASIP_FREQ 30
#define TFAR_MAX_ASIP_FREQ 87

#define TFAR_SW_STEREO_OFFSET 3
#define TFAR_LR_STEREO_OFFSET 3
#define TFAR_MAX_STEREO 3

#define TFAR_CODE_OFFSET 4
#define TFAR_ADDITIONAL_CHANNEL_OFFSET 5
#define TFAR_ADDITIONAL_STEREO_OFFSET 6
#define TFAR_ADDITIONAL_VOLUME_OFFSET 10

#define TFAR_LR_SPEAKER_OFFSET 8
#define TFAR_SW_SPEAKER_OFFSET 8


#define TFAR_PLAYER_RESCAN_TIME 1//Interval between Rescans of Players

#define TFAR_FAR_PLAYER_UPDATE_TIME 3.5 //Interval between updates of Far(>TF_max_voice_volume) Player positions

#define TFAR_VOLUME_WHISPERING  5
#define TFAR_VOLUME_NORMAL      20
#define TFAR_VOLUME_YELLING     60

#define TFAR_MAXREMOTELRRADIODISTANCE 20

#endif
