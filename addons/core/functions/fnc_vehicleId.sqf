#include "script_component.hpp"

/*
 * Name: TFAR_fnc_vehicleId
 *
 * Author: NKey
 * Returns a string with information about the player vehicle, used at the plugin side.
 *
 * Arguments:
 * 0: The unit to check. <OBJECT>
 *
 * Return Value:
 * NetworkID, Turned out <STRING>
 *
 * Example:
 * _vehicleID = player call TFAR_fnc_vehicleID;
 *
 * Public: Yes
 */
params ["_unit"];

if (isNull (objectParent _unit)) exitWith {"no"};//Unit is not in vehicle
private _vehicle = (vehicle _unit);
private _netID = _vehicle getVariable ["TFAR_vehicleIDOverride", netid _vehicle];

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
private _hasIntercom = ([(typeof _vehicle), "TFAR_hasIntercom", 0] call TFAR_fnc_getVehicleConfigProperty) > 0;
private _intercomSlot = -1;

if (_hasIntercom) then {
    _intercomSlot = _vehicle getVariable [format ["TFAR_IntercomSlot_%1",(netID _unit)],0];
};

//could replace the "turnout" string by 0.0 scalar.. But maybe someday the plugin wants to differentiate between turned out or inside a 0 isolation vehicle

[_netID, if (isTurnedOut _unit) then {"turnout"} else {[(typeof _vehicle), "tf_isolatedAmount", 0.0] call TFAR_fnc_getVehicleConfigProperty}, _intercomSlot, velocity _unit] joinString (toString [16])
