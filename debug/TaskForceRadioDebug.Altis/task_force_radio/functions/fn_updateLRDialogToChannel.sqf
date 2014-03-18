#include "define.h"
private ["_channelText", "_formatText"];
_formatText = "CH: %1";

if (typename (_this select 0) == (typename "")) then {
	_formatText = _this select 0;
};

ctrlSetText [IDC_RT1523G_EDIT, TF_lr_dialog_radio call TFAR_fnc_getLrFrequency];
_channelText =  format[_formatText, (TF_lr_dialog_radio call TFAR_fnc_getLrChannel) + 1];
ctrlSetText [IDC_RT1523G_CHANNEL_EDIT, _channelText];