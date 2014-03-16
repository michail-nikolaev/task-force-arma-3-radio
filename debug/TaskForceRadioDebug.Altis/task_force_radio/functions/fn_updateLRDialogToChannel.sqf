#include "define.h"
private ["_channelText"];
ctrlSetText [IDC_RT1523G_EDIT, TF_lr_dialog_radio call TFAR_fnc_getLrFrequency];
_channelText =  format["CH: %1", (TF_lr_dialog_radio call TFAR_fnc_getLrChannel) + 1];
ctrlSetText [IDC_RT1523G_CHANNEL_EDIT, _channelText];