#include "script_component.hpp"

/*
  Name: TFAR_intercom_phone_fnc_activate

  Author: Arend(Saborknight)
    Connects the player to the intercom of a vehicle, if intercom is enabled on
    the vehicle.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_intercom_phone_fnc_activate;

  Public: Yes
*/

params ["_vehicle", "_player"];

private _phoneSpeaker = _vehicle getVariable "TFAR_IntercomPhoneSpeaker";

if (!isNil "_phoneSpeaker") exitWith {
    [parseText format["<br /><br /><t align='center'>%1 is currently on the phone.</t>", name _phoneSpeaker]] call TFAR_fnc_showHint;
    "no";
};

private _vehicleID = _vehicle getVariable ["TFAR_vehicleIDOverride", netId _vehicle];
_vehicle setVariable ["TFAR_vehicleIDOverride", _vehicleID, true];
_vehicle setVariable ["TFAR_IntercomPhoneSpeaker", _player, true];
_player setVariable ["TFAR_IntercomPhoneVehicle", _vehicle, true];
_player setVariable ["TFAR_vehicleIDOverride", _vehicleID, true];

// Get intercom channel, now that we've signed on to the intercom
private _intercomSlot = [_vehicle] call TFAR_intercom_phone_fnc_getIntercomChannel;

_vehicle setVariable [format ["TFAR_IntercomSlot_%1",(netId _player)], _intercomSlot, true];
_player setVariable [format ["TFAR_IntercomSlot_%1",(netId _player)], _intercomSlot, true]; // Because TFAR checks the "vehicle", and thinks the unit is the vehicle when it's not in a vehicle, so we manually set it

// Show indicator
if (TFAR_oldVolumeHint) then {
    [parseText "Connected to Vehicle Intercom", -1] call TFAR_fnc_showHint;
} else {
    (QGVAR(ConnectionIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(ConnectionIndicatorRsc), "PLAIN", 0, true];
};

// Keep connection alive until out of range or disconnected
private _intercomPhoneMaxRange = (((boundingBoxReal _vehicle) select 2) / 2) + 5;
[{
    params ["_vehicle", "_player", "_intercomPhoneMaxRange"];
    (_vehicle distance _player) > _intercomPhoneMaxRange || isNil {_player getVariable "TFAR_IntercomPhoneVehicle"}
}, {
    params ["_vehicle", "_player"];
    [_vehicle, _player] call TFAR_intercom_phone_fnc_deactivate;
}, [_vehicle, _player, _intercomPhoneMaxRange]] call CBA_fnc_waitUntilAndExecute;


// Just in case the player gets into the vehicle or dies/disconnects
_player addEventHandler ["GetInMan", {
    params ["_player", "_role", "_vehicle"];
    // Use 'TFAR_IntercomPhoneVehicle' variable, so that it doesn't matter
    // what vehicle the player enters, the intercom phone will disconnect
    [_player getVariable "TFAR_IntercomPhoneVehicle", _player] call TFAR_intercom_phone_fnc_deactivate;
    _player removeEventHandler ["GetInMan", _thisEventHandler];
}];

_player addMPEventHandler ["MPKilled", {
    params ["_player"];
    [_player getVariable "TFAR_IntercomPhoneVehicle", _player] call TFAR_intercom_phone_fnc_deactivate;
    _player removeMPEventHandler ["MPKilled", _thisEventHandler];
}];

// Just in case the vehicle is destroyed
_vehicle addMPEventHandler ["MPKilled", {
    params ["_vehicle"];
    [_vehicle, _vehicle getVariable "TFAR_IntercomPhoneSpeaker"] call TFAR_intercom_phone_fnc_deactivate;
    _vehicle removeMPEventHandler ["MPKilled", _thisEventHandler];
}];

_player setVariable ["TFAR_IntercomPhoneEHID",
    ["ace_unconscious", {
        params ["_player", "_active"];
        if (_active) then {
            [_player getVariable "TFAR_IntercomPhoneVehicle", _player] call TFAR_intercom_phone_fnc_deactivate;
        };
    }] call CBA_fnc_addEventHandler
];
