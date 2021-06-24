#include "script_component.hpp"

/*
  Name: TFAR_intercom_phone_fnc_deactivate

  Author: Arend(Saborknight)
    Disconnects the player from the intercom of a vehicle.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_intercom_phone_fnc_deactivate;

  Public: Yes
*/

params ["_vehicle", "_player"];

_player setVariable ["TFAR_vehicleIDOverride", nil, true];
_playerEHIDs = _player getVariable ["TFAR_IntercomPhoneEHIDs", [-1, -1]];
_vehicleEHIDs = _vehicle getVariable ["TFAR_IntercomPhoneEHIDs", [-1]];
_player removeEventHandler ["GetInMan", _playerEHIDs select 0];
_player removeMPEventHandler ["MPKilled", _playerEHIDs select 1];
_vehicle removeMPEventHandler ["MPKilled", _vehicleEHIDs select 0];
_player setVariable ["TFAR_IntercomPhoneVehicle", nil];
_vehicle setVariable ["TFAR_IntercomPhoneSpeaker", nil, true];

// Hide indicator
if (TFAR_oldVolumeHint) then {
    [parseText "Disconnected from Vehicle Intercom", 5] call TFAR_fnc_showHint;
} else {
    (QGVAR(ConnectionIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
