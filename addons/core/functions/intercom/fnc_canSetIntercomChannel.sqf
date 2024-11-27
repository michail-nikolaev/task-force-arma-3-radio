#include "script_component.hpp"

/*
  Name: TFAR_fnc_canSetIntercomChannel

  Author: DartRuffian
    Determines if a player can switch their intercom to a specific channel.

  Arguments:
    0: Vehicle <OBJECT>
    1: Player <OBJECT>
    2: Channel <NUMBER>

  Return Value:
    None

  Example:
    [vehicle player, player, 1] = call TFAR_fnc_canSetIntercomChannel;

  Public: No
*/

params ["_vehicle", "_player", ["_channel", -2]];

private _intercom = _vehicle getVariable [format ["TFAR_IntercomSlot_%1", netId _player], -2];
if (_intercom == -2) then {
    _intercom = _vehicle getVariable ["TFAR_defaultIntercomSlot", TFAR_defaultIntercomSlot];
};

_intercom != _channel
