#include "script_component.hpp"

/*
  Name: TFAR_fnc_onSwTangentReleasedHack

  Author: Nkey
    Hack to also trigger SR transmit while sprinting or holding down other modifiers

  Arguments:
    None

  Return Value:
    false <BOOL>

  Example:
    call TFAR_fnc_onSwTangentReleasedHack;

  Public: No
*/

private _scancode = _this select 1;
private _keybind = ["TFAR", "SWTransmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
    private _scancode_sw = ((_keybind) select 5) select 0;
    if (_scancode == _scancode_sw) then {
        call TFAR_fnc_onSwTangentReleased;
    };
};
false
