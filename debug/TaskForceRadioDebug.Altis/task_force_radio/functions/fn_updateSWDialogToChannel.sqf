#include "define.h"
private ["_channelText", "_formatText"];
_formatText = "C%1";

if (typename (_this select 0) == (typename "")) then {
	_formatText = _this select 0;
};

ctrlSetText [IDC_ANPRC152_EDIT, TF_sw_dialog_radio call TFAR_fnc_getSwFrequency];
_channelText =  format[_formatText, (TF_sw_dialog_radio call TFAR_fnc_getSwChannel) + 1];
ctrlSetText [IDC_ANPRC152_CHANNEL_EDIT, _channelText];