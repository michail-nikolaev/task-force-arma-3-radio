#include "script_component.hpp"

/*
  Name: TFAR_fnc_setIntercomChannel

  Author: DartRuffian
    Sets the channel of a player's vehicle intercom.

  Arguments:
    0: Vehicle <OBJECT>
    1: Player <OBJECT>
    2: Channel <NUMBER>

  Return Value:
    None

  Example:
    [vehicle player, player, 1] = call TFAR_fnc_setIntercomChannel;

  Public: Yes
*/

params [
    ["_vehicle", objNull, [objNull]],
    ["_player", objNull, [objNull]],
    ["_channel", 1, [1]]
];

if (!alive _vehicle || !alive _player || !isPlayer _player) exitWith {};

_vehicle setVariable [format ["TFAR_IntercomSlot_%1", netId _player], _channel, true];
["TFAR_intercomChannelSet", [_vehicle, _player, _channel]] call CBA_fnc_localEvent;
nil
