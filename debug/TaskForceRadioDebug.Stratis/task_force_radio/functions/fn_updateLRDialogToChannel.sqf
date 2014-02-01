#include "define.h"
private ["_channelText"];
ctrlSetText [IDC_RT1523G_RADIO_DIALOG_EDIT, lr_dialog_radio call TFAR_fnc_getLrFrequency];
_channelText =  format["CH: %1", (lr_dialog_radio call TFAR_fnc_getLrChannel) + 1];
ctrlSetText [IDC_RT1523G_RADIO_DIALOG_CHANNEL_EDIT, _channelText];