#include "script_component.hpp"

/*
  Name: TFAR_fnc_getIntercomChannel

  Author: Arend(Saborknight)
    Gets the intercom channel in use by the crew of a vehicle,
    in the order of: Driver, Gunner, Commander, Turrets, Cargo

  Arguments:
    0: Vehicle object <OBJECT>

  Return Value:
    Intercom Channel <NUMBER>

  Example:
    [_vehicle, _player] call TFAR_fnc_getIntercomChannel;

  Public: Yes
*/

params ["_vehicle"];

// Get any occupants, from crew down to passengers
private _crew = crew _vehicle;
if (count _crew == 0) exitWith {
    _vehicle getVariable ["TFAR_defaultIntercomSlot", TFAR_defaultIntercomSlot];
};

_vehicle getVariable [format ["TFAR_IntercomSlot_%1",(netID (_crew select 0))],
    _vehicle getVariable ["TFAR_defaultIntercomSlot", TFAR_defaultIntercomSlot]
];
