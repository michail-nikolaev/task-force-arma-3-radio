#include "script_component.hpp"

/*
  Name: TFAR_fnc_getIntercomChannel

  Author: DartRuffian
    Gets the channel of a player's vehicle intercom.

  Arguments:
    0: Vehicle <OBJECT>
    1: Player <OBJECT>

  Return Value:
    The intercom channel <NUMBER>

  Example:
    [vehicle player, player] = call TFAR_fnc_getIntercomChannel;

  Public: Yes
*/

params [
    ["_vehicle", objNull, [objNull]],
    ["_player", objNull, [objNull]]
];

if (!isPlayer _player) exitWith {};

private _intercom = _vehicle getVariable [format ["TFAR_IntercomSlot_%1", netId _player], -2];
if (_intercom == -2) then {
    _intercom = _vehicle getVariable ["TFAR_defaultIntercomSlot", TFAR_defaultIntercomSlot];
};
_intercom;
