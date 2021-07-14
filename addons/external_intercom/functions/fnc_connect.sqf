#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_connect

  Author: Arend(Saborknight)
    Connects the player to the intercom of a vehicle, if intercom is enabled on
    the vehicle.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>
    2: Is Wireless connection? <BOOLEAN>

  Return Value:
    None

  Example:
    [_vehicle, _player] call TFAR_external_intercom_fnc_connect;

  Public: Yes
*/

params ["_vehicle", "_player", "_actionParams"];
_actionParams params [["_wireless", false, [false]]];

if (_wireless && !((headgear _player) in TFAR_externalIntercomWirelessHeadgear)) exitWith {
    [parseText format[CSTRING(HEADGEAR_NOT_WIRELESS_CAPABLE), getText(configFile >> "CfgWeapons" >> headgear _player >> "displayName")]] call TFAR_fnc_showHint;
    "no";
};

private _externalSpeakers = _vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]];
// External Speakers structure is always:
//  [_playerUsingPhone, [_infinitePlayersConnectedWirelessly...]]
if (!isNull (_externalSpeakers select 0) && !_wireless) exitWith {
    [parseText format[CSTRING(SOMEONE_USING_PHONE), name (_externalSpeakers select 0)]] call TFAR_fnc_showHint;
    "no";
};

// Make sure we disconnect properly from any other connected vehicles
private _oldVehicle = _player getVariable "TFAR_ExternalIntercomVehicle";
if (!isNil {_oldVehicle}) then {
    [_oldVehicle, _player] call TFAR_external_intercom_fnc_disconnect;
};

private _vehicleID = _vehicle getVariable ["TFAR_vehicleIDOverride", netId _vehicle];
_vehicle setVariable ["TFAR_vehicleIDOverride", _vehicleID, true];
_player setVariable ["TFAR_ExternalIntercomVehicle", _vehicle, true];
_player setVariable ["TFAR_vehicleIDOverride", _vehicleID, true];

if (_wireless) then {
    (_externalSpeakers select 1) pushBack _player;
} else {
    _externalSpeakers set [0, _player];
};
_vehicle setVariable ["TFAR_ExternalIntercomSpeakers", _externalSpeakers, true];

// Get intercom channel, now that we've signed on to the intercom
private _intercomSlot = [_vehicle] call TFAR_external_intercom_fnc_getIntercomChannel;

_vehicle setVariable [format ["TFAR_IntercomSlot_%1",(netId _player)], _intercomSlot, true];
_player setVariable [format ["TFAR_IntercomSlot_%1",(netId _player)], _intercomSlot, true]; // Because TFAR checks the "vehicle", and thinks the unit is the vehicle when it's not in a vehicle, so we manually set it

// Show indicator
if (TFAR_oldVolumeHint) then {
    [parseText "Connected to Vehicle Intercom", -1] call TFAR_fnc_showHint;
} else {
    (QGVAR(PhoneConnectionIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(PhoneConnectionIndicatorRsc), "PLAIN", 0, true];
};

// Keep connection alive until out of range or disconnected
private _interactionPointRelative = getCenterOfMass _vehicle;
private _intercomMaxRange = TFAR_externalIntercomMaxRange_Wireless;
private _headgear = "";

if !(_wireless) then {
    _interactionPointRelative = [_vehicle] call TFAR_external_intercom_fnc_getInteractionPoint;
    _intercomMaxRange = TFAR_externalIntercomMaxRange_Phone;
} else {
    _headgear = headgear _player;
};

[{
    params ["_vehicle", "_player", "_intercomMaxRange", "_wireless", "_headgear"];
    systemChat str [
        _this,
        ((_vehicle modelToWorld _interactionPointRelative) distance _player),
        isNil {_player getVariable "TFAR_ExternalIntercomVehicle"},
        _wireless,
        !(_headgear isEqualTo (headgear _player)),
        (_wireless && !(_headgear isEqualTo (headgear _player)))
    ];
    ((_vehicle modelToWorld _interactionPointRelative) distance _player) > _intercomMaxRange
    || isNil {_player getVariable "TFAR_ExternalIntercomVehicle"}
    || (_wireless && !(_headgear isEqualTo (headgear _player)))
}, {
    params ["_vehicle", "_player"];
    systemChat "Yikes";
    [_vehicle, _player] call TFAR_external_intercom_fnc_disconnect;
}, [_vehicle, _player, _intercomMaxRange, _wireless, _headgear]] call CBA_fnc_waitUntilAndExecute;


if !(_wireless) then {
    private _handset = createSimpleObject [QPATHTOF(data\TFAR_handset.p3d), _player selectionPosition "head"];
    _handset attachTo [_player, [-0.14,-0.02,0.02], "head", true];
    _handset setVectorDirAndUp [[-2.5,0.8,0.25],[-1,-1,1]];
    private _ropeID = ropeCreate [_vehicle, _interactionPointRelative vectorAdd [0,0.2,0], _handset, "plug", _intercomMaxRange]; // handset rope location[0,0.006,-0.7]
    _vehicle setVariable ["TFAR_ExternalIntercomRopeIDs", [_ropeID, _handset], true];

    _vehicle addEventHandler ["RopeBreak", {
        params ["_vehicle", "_ropeID", "_player"];
        if (((_vehicle getVariable ["TFAR_ExternalIntercomRopeIDs", [nil, nil]]) select 0) isEqualTo _ropeID) then {
            [_vehicle, _player] call TFAR_external_intercom_fnc_disconnect;
            _vehicle removeEventHandler ["RopeBreak", _thisEventHandler];
        };
    }];
} else {

};

// Just in case the player gets into the vehicle or dies/disconnects
_player addEventHandler ["GetInMan", {
    params ["_player", "_role", "_vehicle"];
    // Use 'TFAR_ExternalIntercomVehicle' variable, so that it doesn't matter
    // what vehicle the player enters, the intercom will disconnect
    [_player getVariable "TFAR_ExternalIntercomVehicle", _player] call TFAR_external_intercom_fnc_disconnect;
    _player removeEventHandler ["GetInMan", _thisEventHandler];
}];

_player addMPEventHandler ["MPKilled", {
    params ["_player"];
    [_player getVariable "TFAR_ExternalIntercomVehicle", _player] call TFAR_external_intercom_fnc_disconnect;
    _player removeMPEventHandler ["MPKilled", _thisEventHandler];
}];

// Just in case the vehicle is destroyed
if (isNil {_vehicle getVariable "TFAR_ExternalIntercomEH"}) then {
    _vehicle setVariable ["TFAR_ExternalIntercomEH",
        _vehicle addMPEventHandler ["MPKilled", {
            params ["_vehicle"];
            {
                [_vehicle, _x] call TFAR_external_intercom_fnc_disconnect;
            } forEach ((_vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]]) select 1);
            _vehicle removeMPEventHandler ["MPKilled", _thisEventHandler];
        }],
        true
    ];
};

_player setVariable ["TFAR_ExternalIntercomEHID",
    ["ace_unconscious", {
        params ["_player", "_active"];
        if (_active) then {
            [_player getVariable "TFAR_ExternalIntercomVehicle", _player] call TFAR_external_intercom_fnc_disconnect;
        };
    }] call CBA_fnc_addEventHandler
];
