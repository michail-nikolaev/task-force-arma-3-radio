#include "define.h"
private ["_channelText"];
ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT, sw_dialog_radio call TFAR_fnc_getSwFrequency];
_channelText =  format["C%1", (sw_dialog_radio call TFAR_fnc_getSwChannel) + 1];
ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_CHANNEL_EDIT, _channelText];