#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setVolumeViaDialog
 *
 * Author: L-H
 * sets the volume of the current dialog radio.
 *
 * Arguments:
 * 0: Mouse button pressed (0,1) <NUMBER>
 * 1: LR radio (0,1) <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 *      // LR radio
 *      [_this select 1, true] call TFAR_fnc_setVolumeViaDialog;
 *      // SW radio
 *      [_this select 1, false] call TFAR_fnc_setVolumeViaDialog;
 *
 * Public: Yes
 */

playSound "TFAR_rotatorPush";

params ["_btn", "_lr"];

private _maxVolume = 0;
private _radio = "";
private _fnc_GetVolume = {};

if (_lr) then {
    _maxVolume = TF_MAX_LR_VOLUME;
    _radio = TF_lr_dialog_radio;
    _fnc_GetVolume = TFAR_fnc_getLrVolume;
} else {
    _maxVolume = TF_MAX_SW_VOLUME;
    _radio = TF_sw_dialog_radio;
    _fnc_GetVolume = TFAR_fnc_getSwVolume;
};

private _vChange = if(_btn == 0)then{-1 + _maxVolume}else {1};
_vChange = ((_radio call _fnc_GetVolume) + _vChange) mod _maxVolume;

if (_lr) then {
    [_radio, _vChange] call TFAR_fnc_setLrVolume;
} else {
    [_radio,_vChange] call TFAR_fnc_setSwVolume;
};
[_radio] call TFAR_fnc_showRadioVolume;
