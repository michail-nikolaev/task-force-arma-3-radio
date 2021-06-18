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
terminate (_player getVariable ["TFAR_IntercomPhoneLoopID", nil]);
_EHIDs = _player getVariable ["TFAR_IntercomPhoneEHIDs", [-1, -1]];
_player removeEventHandler ["GetInMan", _EHIDs select 0];
_player removeMPEventHandler ["MPKilled", _EHIDs select 1];
_player setVariable ["TFAR_IntercomPhoneLoopID", nil];
_vehicle setVariable ["TFAR_IntercomPhoneSpeaker", nil, true];

// Hide indicator
if (TFAR_oldVolumeHint) then {
    // [parseText "Disconnected from Vehicle Intercom", 5] call TFAR_fnc_showHint;
} else {
    (QGVAR(ConnectionIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
