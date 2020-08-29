#include "script_component.hpp"

/*
  Name: TFAR_fnc_onSwTangentReleased

  Author: NKey
    Fired when the keybinding for SR is released.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onSwTangentReleased;

  Public: No
*/

if ((!TF_tangent_sw_pressed) or {!alive TFAR_currentUnit}) exitWith {false};

private _radio = call TFAR_fnc_activeSwRadio;
private _channel = _radio call TFAR_fnc_getSwChannel;
private _currentFrequency = [_radio, _channel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmitEnd;

TF_tangent_sw_pressed = false;
false
