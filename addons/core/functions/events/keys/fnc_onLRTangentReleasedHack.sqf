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

if (!TF_tangent_lr_pressed) exitWith {false};

private _scancode = _this select 1;

{
    private _releasedAction = _x select 4; //https://cbateam.github.io/CBA_A3/docs/files/keybinding/fnc_getKeybind-sqf.html
    private _keyBinds = _x select 8;

    {
        _x params ["_scanCodeTarget", "_mods"];

         if (
           ((_scancode == SHIFTL) && (_mods select 0)) ||
           ((_scancode == CTRLL) && (_mods select 1)) ||
           ((_scancode == ALTL) && (_mods select 2)) ||
           (_scancode == _scanCodeTarget))
        then _releasedAction;
    } forEach _keyBinds;
} forEach [
    ["TFAR", "LRTransmit"] call cba_fnc_getKeybind,
    ["TFAR", "LRTransmitAdditional"] call cba_fnc_getKeybind
];


false
