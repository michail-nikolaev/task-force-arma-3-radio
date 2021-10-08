#include "script_component.hpp"

/*
  Name: TFAR_fnc_getIntercomChannel

  Author: Arend(Saborknight)
    Gets the player's intercom channel, otherwise gets the intercom channel in
    use by the crew of a vehicle, in the order of: Driver, Gunner, Commander,
    Turrets, Cargo. Otherwise gets default intercom channel of the vehicle

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player object <OBJECT>

  Return Value:
    Intercom Channel <NUMBER>

  Example:
    [_vehicle, _player] call TFAR_fnc_getIntercomChannel;

  Public: Yes
*/
params ["_vehicle", "_player"];

// Get any occupants, from crew down to passengers
private _crew = crew _vehicle;
_vehicle getVariable [format ["TFAR_IntercomSlot_%1", netId _player],
    _vehicle getVariable [format ["TFAR_IntercomSlot_%1",(netId (_crew select 0))],
        _vehicle getVariable ["TFAR_defaultIntercomSlot", TFAR_defaultIntercomSlot]
    ]
];
