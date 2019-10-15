#include "script_component.hpp"

/*
  Name: TFAR_fnc_onTangentPressedHack

  Author: Nkey
    Hack to also trigger SR/LR transmit while sprinting or holding down other modifiers

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onTangentPressedHack;

  Public: No
*/

params ["","_scancode","_shift","_ctrl","_alt"];

if !(call TFAR_fnc_isAbleToUseRadio) exitWith {false};

private _matchbox = [];
private _modifiers = [_shift,_ctrl,_alt];

private _fnc_matchModifiers = {
  params ["_targetScancode", "_targetMods"];

  if !(_scancode isEqualTo _targetScancode) exitWith {false};
      private _modsMatch = 0;
      {
          if (!_x || _modifiers select _forEachIndex) then {_modsMatch = _modsMatch + 1;}
      } forEach _targetMods;
      _modsMatch == 3; //If all required Modifiers are pressed then is Matching
};

{
    private _pressedAction = _x select 3; //https://cbateam.github.io/CBA_A3/docs/files/keybinding/fnc_getKeybind-sqf.html
    private _keyBinds = _x select 8;

    //diag_log ["iter", _pressedAction, _keyBinds];

    {
        _x params ["_scanCodeTarget", "_modifiersTarget"];
        private _isMatch = [_scanCodeTarget, _modifiersTarget] call _fnc_matchModifiers;

        //diag_log ["match", _pressedAction, _x, _isMatch];

        if (_isMatch) then {
          _matchbox pushBack [{_x} count _modifiersTarget, _pressedAction];
        }
    } forEach _keyBinds;
} forEach [
    ["TFAR", "SWTransmit"] call cba_fnc_getKeybind,
    ["TFAR", "SWTransmitAdditional"] call cba_fnc_getKeybind,
    ["TFAR", "LRTransmit"] call cba_fnc_getKeybind,
    ["TFAR", "LRTransmitAdditional"] call cba_fnc_getKeybind
];

_matchBox sort false; //Check the radio that has more modifiers first

//diag_log ["#4 mb", _matchBox];

call ((_matchbox param [0, []]) param [1, {}]); //Call the first function