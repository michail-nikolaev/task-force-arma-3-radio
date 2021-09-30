#include "script_component.hpp"

/*
  Name: TFAR_fnc_onSwTangentPressed

  Author: NKey
    Fired when the keybinding for SR is pressed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onSwTangentPressed;

  Public: No
*/

if (time - TF_last_lr_tangent_press < 0.5) exitWith {false};
if (((TF_tangent_lr_pressed or TF_tangent_sw_pressed)) or {!alive TFAR_currentUnit} or {!call TFAR_fnc_haveSWRadio}) exitWith {false};

if (!isMultiplayer) exitWith {_x = localize LSTRING(WM_Singleplayer);systemChat _x;hint _x;false};

if (!call TFAR_fnc_isAbleToUseRadio) exitWith {call TFAR_fnc_unableToUseHint;false};

private _radio = call TFAR_fnc_activeSwRadio;
private _channel = _radio call TFAR_fnc_getSwChannel;
private _currentFrequency = [_radio, _channel + 1] call TFAR_fnc_getChannelFrequency;

[_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmit;

TF_tangent_sw_pressed = true;
false
