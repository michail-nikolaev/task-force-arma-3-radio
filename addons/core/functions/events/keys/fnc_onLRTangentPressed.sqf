#include "script_component.hpp"

/*
  Name: TFAR_fnc_onLRTangentPressed

  Author: NKey
    Fired when the keybinding for LR is pressed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onLRTangentPressed;

  Public: No
*/
if (time - TF_last_lr_tangent_press < 0.1) exitWith {TF_last_lr_tangent_press = time;false};
TF_last_lr_tangent_press = time;
if ((TF_tangent_lr_pressed or TF_tangent_sw_pressed) or {!alive TFAR_currentUnit} or {!call TFAR_fnc_haveLRRadio}) exitWith {false};

if (!isMultiplayer) exitWith {_x = localize LSTRING(WM_Singleplayer);systemChat _x;hint _x;false};

if (!call TFAR_fnc_isAbleToUseRadio) exitWith {call TFAR_fnc_unableToUseHint;false};
private _radio = call TFAR_fnc_activeLrRadio;
private _channel = _radio call TFAR_fnc_getLrChannel;
private _currentFrequency = [_radio, _channel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doLRTransmit;

TF_tangent_lr_pressed = true;
false
