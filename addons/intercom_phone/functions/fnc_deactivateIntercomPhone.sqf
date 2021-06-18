#include "script_component.hpp"

/*
  Name: TFAR_fnc_deactivateIntercomPhone

  Author: Arend(Saborknight)
    Disconnects the player from the intercom of a vehicle.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_fnc_deactivateIntercomPhone;

  Public: Yes
*/

params ["_vehicle", "_player"];

diag_log "Hanging up the intercom phone";

_player setVariable ["TFAR_vehicleIDOverride", nil, true];
terminate (_player getVariable ["IntercomPhoneLoopID", nil]);
_player removeEventHandler ["GetInMan", _player getVariable ["IntercomPhoneEHID", -1]];
_player setVariable ["IntercomPhoneLoopID", nil];
_vehicle setVariable ["IntercomPhoneSpeaker", nil, true];

// Hide indicator
if (TFAR_oldVolumeHint) then {
    [parseText "Disconnected from Vehicle Intercom", 5] call TFAR_fnc_showHint;
} else {
    ("TFAR_core_HUDIntercomPhoneIndicatorRsc" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
};
