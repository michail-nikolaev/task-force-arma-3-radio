#include "script_component.hpp"

/*
  Name: TFAR_fnc_activateIntercomPhone

  Author: Arend(Saborknight)
    Connects the player to the intercom of a vehicle, if intercom is enabled on
    the vehicle.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_fnc_activateIntercomPhone;

  Public: Yes
*/

params ["_vehicle", "_player"];
hint format["Target: %1, Player: %2", _vehicle, _player];
private _phoneSpeaker = _vehicle getVariable ["IntercomPhoneSpeaker", nil];

if (!isNil "_phoneSpeaker") exitWith {
    [parseText format["<br /><br /><t align='center'>%1 is currently on the phone.</t>", name _phoneSpeaker]] call TFAR_fnc_showHint;
    "no";
};

private _vehicleID = _vehicle getVariable ["TFAR_vehicleIDOverride", netid _vehicle];
_vehicle setVariable ["TFAR_vehicleIDOverride", _vehicleID, true];
_vehicle setVariable ["IntercomPhoneSpeaker", _player, true];
_player setVariable ["TFAR_vehicleIDOverride", _vehicleID, true];

// Get intercom channel, now that we've signed on to the intercom
private _intercomSlot = [_vehicle] call fnc_getIntercomChannel;
_vehicle setVariable [format ["TFAR_IntercomSlot_%1",(netID _player)], _intercomSlot];
_player setVariable [format ["TFAR_IntercomSlot_%1",(netID _player)], _intercomSlot]; // Because TFAR checks the "vehicle", and thinks the unit is the vehicle when it's not in a vehicle, so we manually set it

// Show indicator
if (TFAR_oldVolumeHint) then {
    [parseText "Connected to Vehicle Intercom", -1] call TFAR_fnc_showHint;
} else {
    ("TFAR_core_HUDIntercomPhoneIndicatorRsc" call BIS_fnc_rscLayer) cutRsc ["TFAR_core_HUDIntercomPhoneIndicatorRsc", "PLAIN", 0, true];
};

private _loopID = [_vehicle, _player] spawn {
    params ["_vehicle", "_player"];

    while {true} do {
        if ((_vehicle distance _player) > ((((boundingBoxReal _vehicle) select 2) / 2) + 5)) then {
            [_vehicle, _player] call fnc_deactivate;
        };
        sleep 3;
    };
};

_player setVariable ["IntercomPhoneLoopID", _loopID];

// Just in case the caller gets into the vehicle
_player setVariable ["IntercomPhoneEHID",
    _player addEventHandler ["GetInMan", {
        params ["_player", "_role", "_vehicle"];
        [_vehicle, _player] call fnc_deactivate;
    }]
];
