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

{
    private _releasedAction = _x select 4; //https://cbateam.github.io/CBA_A3/docs/files/keybinding/fnc_getKeybind-sqf.html
    private _keyBinds = _x select 8;

    {
        _x params ["_scanCodeTarget", "_mods"];

         if (_scancode == _scanCodeTarget) then _releasedAction;
    } forEach _keyBinds;
} forEach [
    ["TFAR", "SWTransmit"] call cba_fnc_getKeybind,
    ["TFAR", "SWTransmitAdditional"] call cba_fnc_getKeybind
];


false
