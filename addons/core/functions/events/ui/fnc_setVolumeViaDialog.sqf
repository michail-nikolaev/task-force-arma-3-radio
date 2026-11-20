#include "script_component.hpp"

/*
  Name: TFAR_fnc_setVolumeViaDialog

  Author: Garth de Wet (L-H)
    sets the volume of the current dialog radio.

  Arguments:
    0: Mouse button pressed (0,1) <NUMBER>
    1: Long-range radio <BOOL>

  Return Value:
    None

  Example:
    // LR radio
    [_this select 1, true] call TFAR_fnc_setVolumeViaDialog;
    // SW radio
    [_this select 1, false] call TFAR_fnc_setVolumeViaDialog;

  Public: Yes
*/

playSound "TFAR_rotatorPush";

params ["_button", "_isLrRadio"];

private _radio = missionNamespace getVariable (["TF_sw_dialog_radio", "TF_lr_dialog_radio"] select _isLrRadio);
private _maxVolume = missionNamespace getVariable (["TF_MAX_SW_VOLUME", "TF_MAX_LR_VOLUME"] select _isLrRadio);
private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);
private _additionalChannel = _settings param [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1];
private _additional = _additionalChannel >= 0 && {_additionalChannel == (_settings param [ACTIVE_CHANNEL_OFFSET, 0])};

private _volume = _settings param [VOLUME_OFFSET, 0];
private _setVolume = [TFAR_fnc_setSwVolume, TFAR_fnc_setLrVolume] select _isLrRadio;
if (_additional) then {
    _volume = _settings param [TFAR_ADDITIONAL_VOLUME_OFFSET, _volume];
    _setVolume = [TFAR_fnc_setAdditionalSwVolume, TFAR_fnc_setAdditionalLrVolume] select _isLrRadio;
};
private _step = if (_button == 0) then {_maxVolume - 1} else {1};
[_radio, (_volume + _step) mod _maxVolume] call _setVolume;
[_radio, _additional] call TFAR_fnc_showRadioVolume;
