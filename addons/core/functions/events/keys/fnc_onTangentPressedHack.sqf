#include "script_component.hpp"

/*
    Name: TFAR_fnc_onTangentPressedHack

    Author(s):
        NKey

    Description:
        Hack to also trigger SW/LR transmit while sprinting or holding down other modifiers

    Parameters:

    Returns:
        BOOLEAN

    Example:
        call TFAR_fnc_onTangentPressedHack;
*/

params ["","_scancode","_shift","_ctrl","_alt"];

if !(call TFAR_fnc_isAbleToUseRadio) exitWith {false};

private _sw_keybind = ["TFAR", "SWTransmit"] call cba_fnc_getKeybind;
private _lr_keybind = ["TFAR", "LRTransmit"] call cba_fnc_getKeybind;
private _modifiers = [_shift,_ctrl,_alt];
if (!(isNil "_sw_keybind") and !(isNil "_lr_keybind")) then {
    private _swMods = ((_sw_keybind) select 5) select 1;
    private _lrMods = ((_lr_keybind) select 5) select 1;
    private _scancode_lr = ((_lr_keybind) select 5) select 0;
    private _scancode_sw = ((_sw_keybind) select 5) select 0;

    if !(_scanCode in [_scancode_sw,_scancode_lr]) exitWith {false};

    private _lrMatch = false;
    if (_scancode isEqualTo _scancode_lr) then {
        private _lrModsMatch = 0;
        {
            if (!_x || _modifiers select _forEachIndex) then {_lrModsMatch = _lrModsMatch + 1;}
        } forEach _lrMods;
        _lrMatch = _lrModsMatch == 3; //If all required Modifiers are pressed then LR is Matching
    };
    private _swMatch = false;
    if (_scancode isEqualTo _scancode_sw) then {
        private _swModsMatch = 0;
        {
            if (!_x || _modifiers select _forEachIndex) then {_swModsMatch = _swModsMatch + 1;}
        } forEach _swMods;
        _swMatch = _swModsMatch == 3; //If all required Modifiers are pressed then LR is Matching
    };

    if (({_x} count _swMods) > ({_x} count _lrMods)) then {//Check the radio that has more modifiers first
        if (_swMatch) exitWith {call TFAR_fnc_onSwTangentPressed};
        if (_lrMatch) exitWith {call TFAR_fnc_onLrTangentPressed};
    } else {
        if (_lrMatch) exitWith {call TFAR_fnc_onLrTangentPressed};
        if (_swMatch) exitWith {call TFAR_fnc_onSwTangentPressed};
    }
};
