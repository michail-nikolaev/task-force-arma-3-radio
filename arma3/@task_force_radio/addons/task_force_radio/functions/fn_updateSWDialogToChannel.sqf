#include "\task_force_radio\define.h"
private ["_channelText"];
ctrlSetText [IDC_ANPRC152_EDIT, TF_sw_dialog_radio call TFAR_fnc_getSwFrequency];
_channelText =  format["C%1", (TF_sw_dialog_radio call TFAR_fnc_getSwChannel) + 1];
ctrlSetText [IDC_ANPRC152_CHANNEL_EDIT, _channelText];