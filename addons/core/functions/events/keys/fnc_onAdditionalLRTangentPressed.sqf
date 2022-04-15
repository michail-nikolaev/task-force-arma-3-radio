#include "script_component.hpp"

/*
  Name: TFAR_fnc_onAdditionalLRTangentPressed

  Author: NKey
    Fired when the additional keybinding for LR is pressed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onAdditionalLRTangentPressed;

  Public: No
*/

if ((TF_tangent_lr_pressed or TF_tangent_sw_pressed) or {!alive TFAR_currentUnit} or {!call TFAR_fnc_haveLRRadio}) exitWith {false};

if (!isMultiplayer) exitWith {_x = localize LSTRING(WM_Singleplayer);systemChat _x;hint _x; false};

if (!call TFAR_fnc_isAbleToUseRadio) exitWith {call TFAR_fnc_unableToUseHint;false};

private _radio = call TFAR_fnc_activeLrRadio;
private _additionalChannel = _radio call TFAR_fnc_getAdditionalLrChannel;
if (_additionalChannel < 0) exitWith {false}; // No Additional Channel set
private _currentFrequency = [_radio, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _additionalChannel, _currentFrequency, true] call TFAR_fnc_doLRTransmit;

TF_tangent_lr_pressed = true;
false
