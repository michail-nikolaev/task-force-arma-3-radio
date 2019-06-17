#include "script_component.hpp"

/*
  Name: TFAR_fnc_canUseSWRadio

  Author: NKey
    Checks whether the radio would be able to be used at passed depth.

  Arguments:
    0: Unit <OBJECT>
    1: Isolated and inside <BOOL>
    2: Can Speak <BOOL>
    3: Eye height ASL <NUMBER>

  Return Value:
    radio can be used <BOOL>

  Example:
    _canUseSW = [player, false, false, 10] call TFAR_fnc_canUseSWRadio;

  Public: Yes
*/

params ["_player", "_isolated_and_inside", "_can_speak", "_depth"];

private _result = false;

if (_depth > 0) exitWith {true};

(_isolated_and_inside or {isAbleToBreathe _player})
