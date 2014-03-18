#include "define.h"
private ["_channelText", "_formatText"];
_formatText = "C%1";

if ((typename(_this) == typename ([])) and {count _this > 0} and  {typename (_this select 0) == (typename "")}) then {	
	_formatText = _this select 0;
};

ctrlSetText [SW_EDIT, TF_sw_dialog_radio call TFAR_fnc_getSwFrequency];
_channelText =  format[_formatText, (TF_sw_dialog_radio call TFAR_fnc_getSwChannel) + 1];
ctrlSetText [SW_CHANNEL, _channelText];