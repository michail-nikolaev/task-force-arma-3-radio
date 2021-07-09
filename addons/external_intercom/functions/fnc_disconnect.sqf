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

["ace_unconscious", _player getVariable ["TFAR_ExternalIntercomEHID", -1]] call CBA_fnc_removeEventHandler;
_player setVariable ["TFAR_vehicleIDOverride", nil, true];
_player setVariable ["TFAR_ExternalIntercomVehicle", nil, true];
_vehicle setVariable ["TFAR_ExternalIntercomSpeaker", nil, true];

// Kill the rope and model
(_vehicle getVariable ["TFAR_ExternalIntercomRopeIDs", [nil, nil]]) params ["_ropeID", "_handset"];
deleteVehicle _handset;
ropeDestroy _ropeID;
_vehicle setVariable ["TFAR_ExternalIntercomRopeIDs", [], true];

// Hide indicator
if (TFAR_oldVolumeHint) then {
    [parseText CSTRING(DISCONNECT), 5] call TFAR_fnc_showHint;
} else {
    (QGVAR(PhoneConnectionIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
