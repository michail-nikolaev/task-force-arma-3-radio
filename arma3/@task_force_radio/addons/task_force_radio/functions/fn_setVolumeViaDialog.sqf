/*
   Name: TFAR_fnc_setVolumeViaDialog

   Author(s):
    L-H

   Description:
    Sets the volume of the current Dialog radio.

  Parameters:
    0: NUMBER - Mouse button pressed (0,1)
    1: BOOL - LR radio

   Returns:
    NOTHING

   Example:
    // LR radio
    [_this select 1, true] call TFAR_fnc_setVolumeViaDialog;
    // SW radio
    [_this select 1, false] call TFAR_fnc_setVolumeViaDialog;
*/
private ["_vChange", "_radio", "_lr", "_maxVolume", "_currentVolume", "_fnc_GetVolume"];
playSound "TFAR_rotatorPush";

_lr = _this select 1;
_maxVolume = 0;
_radio = "";
_fnc_GetVolume = {};
if (_lr) then {
  _maxVolume = TF_MAX_LR_VOLUME;
  _radio = TF_lr_dialog_radio;
  _fnc_GetVolume = TFAR_fnc_getLrVolume;
}else{
  _maxVolume = TF_MAX_SW_VOLUME;
  _radio = TF_sw_dialog_radio;
  _fnc_GetVolume = TFAR_fnc_getSwVolume;
};
_vChange = if((_this select 0) == 0)then{-1 + _maxVolume}else{1};
_vChange = ((_radio call _fnc_GetVolume) + _vChange) mod _maxVolume;

if (_lr) then {
  [_radio select 0, _radio select 1, _vChange] call TFAR_fnc_setLrVolume;
}else{
  [_radio,_vChange] call TFAR_fnc_setSwVolume;
};
[_radio] call TFAR_fnc_ShowRadioVolume;
