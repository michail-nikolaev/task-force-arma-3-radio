#include "script_component.hpp"

/*
  Name: TFAR_fnc_onAdditionalLRTangentReleased

  Author: NKey
    Fired when the additional keybinding for LR is relesed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onAdditionalLRTangentReleased;

  Public: No
*/

if (!(TF_tangent_lr_pressed) or {!alive TFAR_currentUnit}) exitWith {false};
private _radio = call TFAR_fnc_activeLrRadio;

private _additionalChannel = _radio call TFAR_fnc_getAdditionalLrChannel;
if (_additionalChannel < 0) exitWith {false}; // No Additional Channel set
private _currentFrequency = [_radio, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _additionalChannel, _currentFrequency, true] call TFAR_fnc_doLRTransmitEnd;

TF_tangent_lr_pressed = false;
false
