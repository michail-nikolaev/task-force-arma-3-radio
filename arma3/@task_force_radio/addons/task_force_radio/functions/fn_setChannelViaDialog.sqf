/*
   Name: TFAR_fnc_setChannelViaDialog

   Author(s):
    L-H

   Description:
    Sets the channel of the current Dialog radio.

  Parameters:
    0: NUMBER - Mouse button pressed (0,1)
    1: BOOL - LR radio
    2: STRING - (OPTIONAL) Update formatting.

   Returns:
    NOTHING

   Example:
    // LR radio
    [_this select 1, true] call TFAR_fnc_setChannelViaDialog;
    // SW radio
    [_this select 1, false] call TFAR_fnc_setChannelViaDialog;
*/
private ["_cChange", "_radio", "_lr", "_maxChannels", "_currentChannel", "_fnc_GetChannel", "_format"];
playSound "TFAR_rotatorPush";
_format = "";
if (count _this > 2) then {
  _format = _this select 2;
};
_lr = _this select 1;
_maxChannels = 0;
_radio = "";
_fnc_GetChannel = {};
if (_lr) then {
  _maxChannels = TF_MAX_LR_CHANNELS;
  _radio = TF_lr_dialog_radio;
  _fnc_GetChannel = TFAR_fnc_getLrChannel;
}else{
  _maxChannels = TF_MAX_CHANNELS;
  _radio = TF_sw_dialog_radio;
  _fnc_GetChannel = TFAR_fnc_getSwChannel;
};
_cChange = if((_this select 0) == 0)then{-1 + _maxChannels}else{1};
_cChange = ((_radio call _fnc_GetChannel) + _cChange) mod _maxChannels;

if (_lr) then {
  [_radio select 0, _radio select 1, _cChange] call TFAR_fnc_setLRChannel;
  if (_format != "") then {
    _format call TFAR_fnc_updateLRDialogToChannel;
  }else{
    call TFAR_fnc_updateLRDialogToChannel;
  };
}else{
  [_radio, _cChange] call TFAR_fnc_setSwChannel;
  if (_format != "") then {
    _format call TFAR_fnc_updateSWDialogToChannel;
  }else{
    call TFAR_fnc_updateSWDialogToChannel;
  };
};
[_radio, _lr] call TFAR_fnc_ShowRadioInfo;
