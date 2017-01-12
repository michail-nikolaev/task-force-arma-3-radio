#include "script_component.hpp"

/*
    Name: TFAR_fnc_vehicleID

    Author(s):
        NKey

    Description:
        Returns a string with information about the player vehicle, used at the plugin side.

    Parameters:
        0: OBJECT - The unit to check.

    Returns:
        STRING - NetworkID, Turned out

    Example:
        _vehicleID = player call TFAR_fnc_vehicleID;
*/
params ["_unit"];

if (isNull (objectParent _unit)) exitWith {"no"};//Unit is not in vehicle

private _netID = netid (vehicle _unit);

if (isTurnedOut _unit) exitWith {_netID + "_turnout";};//TFAR_fnc_isTurnedOut is 0.0122ms vs isTurnedOut 0.0023ms


/*
Probably was tired when writing this.. Completed this and then realized it's useless for intercom
But maybe it has some use later. Returns which slot unit is in (driver,commander,gunner,cargo)
private _crew = fullCrew (vehicle _unit);
private _slot = "cargo";
{
    if (_x select 0 isEqualTo _unit) exitWith {_slot = _x select 1;};
    true;
} count _crew;
tolower _slot
*/
//Get intercom slot of unit. By default everyone is Cargo
private _hasIntercom = ([(typeof (vehicle _unit)), "TFAR_hasIntercom", 0] call TFAR_fnc_getConfigProperty) > 0;
private _intercomSlot = -1;

if (_hasIntercom) then {
    _intercomSlot = (vehicle _unit) getVariable [format ["TFAR_IntercomSlot_%1",(netID _unit)],0];
};

[_netID,([(typeof (vehicle _unit)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty),_intercomSlot] joinString (toString [16])
