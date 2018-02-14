#include "script_component.hpp"

/*
  Name: TFAR_fnc_onLRTangentReleasedHack

  Author: Nkey
    Hack to also trigger LR transmit while sprinting or holding down other modifiers

  Arguments:
    None

  Return Value:
    false <BOOL>

  Example:
    call TFAR_fnc_onLRTangentReleasedHack;

  Public: No
 */


private _scancode = _this select 1;
private _keybind = ["TFAR", "LRTransmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
    private _mods = ((_keybind) select 5) select 1;
    private _scancode_lr = ((_keybind) select 5) select 0;

    if (((_scancode == SHIFTL) and (_mods select 0))
       or ((_scancode == CTRLL) and (_mods select 1))
       or ((_scancode == ALTL) and (_mods select 2))
       or (_scancode == _scancode_lr))
     then {
        call TFAR_fnc_onLRTangentReleased;
    };
};
false
