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

private _oldChannel = [_vehicle, _player] call TFAR_fnc_getIntercomChannel;

_vehicle setVariable [format ["TFAR_IntercomSlot_%1", netId _player], _channel, true];
["OnIntercomChannelSet", [_vehicle, _player, _channel, _oldChannel]] call TFAR_fnc_fireEventHandlers;
nil
