#include "script_component.hpp"

/*
  Name: TFAR_fnc_onAdditionalSwTangentReleased

  Author: NKey
    Fired when the additional keybinding for SR is relesed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onAdditionalSwTangentReleased;

  Public: No
*/

if (!TF_tangent_sw_pressed) exitWith {false};
private _radio = call TFAR_fnc_activeSwRadio;

private _additionalChannel = _radio call TFAR_fnc_getAdditionalSwChannel;
if (_additionalChannel < 0) exitWith {false}; //No Additional Channel set
private _currentFrequency = [_radio, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _additionalChannel, _currentFrequency, true] call TFAR_fnc_doSRTransmitEnd;

TF_tangent_sw_pressed = false;
false
