#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_disconnect

  Author: Arend(Saborknight)
    Disconnects the player from the intercom of a vehicle.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_external_intercom_fnc_disconnect;

  Public: Yes
*/

params ["_vehicle", "_player"];

{
    if (count _x isEqualTo 2) then {
        [_player, _x select 1] call (_x select 0);
    };
} forEach (_player getVariable ["TFAR_ExternalIntercomEHs", []]);
_player setVariable ["TFAR_ExternalIntercomEHs", nil];
_player setVariable ["TFAR_vehicleIDOverride", nil, true];
_player setVariable ["TFAR_ExternalIntercomVehicle", nil, true];

_externalIntercomSpeakers = _vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]];

if ((_externalIntercomSpeakers select 0) isEqualTo _player) then {
    _externalIntercomSpeakers set [0, objNull];
};
(_externalIntercomSpeakers select 1) deleteAt ((_externalIntercomSpeakers select 1) find _player);

_vehicle setVariable ["TFAR_ExternalIntercomSpeakers", _externalIntercomSpeakers, true];

// Kill the rope and model
(_vehicle getVariable ["TFAR_ExternalIntercomRopeIDs", [nil, nil]]) params ["_ropeID", "_handset"];
if !(isNil "_ropeID" || isNil "_handset") then {
    deleteVehicle _handset;
    ropeDestroy _ropeID;
    _vehicle setVariable ["TFAR_ExternalIntercomRopeIDs", nil, true];
};

// Hide indicator
(QGVAR(PhoneConnectionIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
