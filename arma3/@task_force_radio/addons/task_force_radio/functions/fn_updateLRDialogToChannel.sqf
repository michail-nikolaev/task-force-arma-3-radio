#include "\task_force_radio\define.h"
private ["_channelText", "_formatText"];
_formatText = "CH: %1";

if ((typename(_this) == typename ([])) and {count _this > 0} and  {typename (_this select 0) == (typename "")}) then {	
	_formatText = _this select 0;
};

ctrlSetText [LR_EDIT, TF_lr_dialog_radio call TFAR_fnc_getLrFrequency];
_channelText =  format[_formatText, (TF_lr_dialog_radio call TFAR_fnc_getLrChannel) + 1];
ctrlSetText [LR_CHANNEL, _channelText];