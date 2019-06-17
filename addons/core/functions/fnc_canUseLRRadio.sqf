#include "script_component.hpp"

/*
  Name: TFAR_fnc_canUseLRRadio

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
    _canUseSW = [player, false, false, 10] call TFAR_fnc_canUseLrRadio;

  Public: Yes
*/

params ["_player", "_isolated_and_inside", "_depth"];

if (_depth > 0) exitWith {true};

if ((vehicle _player != _player) and {_depth > TF_UNDERWATER_RADIO_DEPTH}) then {
    if ((_isolated_and_inside) or {isAbleToBreathe _player}) exitWith {true};
};

false
