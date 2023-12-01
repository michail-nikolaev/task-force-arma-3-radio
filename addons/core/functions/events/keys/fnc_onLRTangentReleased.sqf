#include "script_component.hpp"

/*
  Name: TFAR_fnc_onLRTangentReleased

  Author: NKey
    Fired when the keybinding for LR is released.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onLRTangentReleased;

  Public: No
*/

if (!TF_tangent_lr_pressed) exitWith {false};

private _radio = call TFAR_fnc_activeLrRadio;
private _channel = _radio call TFAR_fnc_getLrChannel;
private _currentFrequency = [_radio, _channel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doLRTransmitEnd;

TF_tangent_lr_pressed = false;
false
