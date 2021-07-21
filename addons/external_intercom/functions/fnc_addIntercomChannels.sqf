#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_addIntercomChannels

  Author: Arend(Saborknight)
    Adds all the intercom channels from the target vehicle as children to the
    current interaction menu parent.

  Arguments:
    0: Vehicle object <OBJECT>

  Return Value:
    ACE Actions of the Intercom Channels to insert as children <ARRAY>

  Example:
    [_vehicle] call TFAR_external_intercom_fnc_addIntercomChannels;

  Public: Yes
*/

params ["_target", "_player", "_params"];

_vehicle = _player getVariable "TFAR_ExternalIntercomVehicle";
private _intercomChannels = (configFile >> "CfgVehicles" >> typeOf _vehicle >> "ACE_SelfActions" >> "TFAR_IntercomChannel") call BIS_fnc_getCfgSubClasses;
private _channelId = -1;
private _searchTerm = "ACE_Player)],";
private _statement = "";

_intercomChannels = _intercomChannels apply {
    _statement = getText(configFile >> "CfgVehicles" >> typeOf _vehicle >> "ACE_SelfActions" >> "TFAR_IntercomChannel" >> _x >> "statement");
    _channelId = [_statement select [((_statement find _searchTerm) + count _searchTerm),2], "-0123456789"] call BIS_fnc_filterString;
    [getText(configFile >> "CfgVehicles" >> typeOf _vehicle >> "ACE_SelfActions" >> "TFAR_IntercomChannel" >> _x >> "displayName"), _channelId];
};

if (_intercomChannels isEqualTo []) exitWith {false;};

private _actions = [];

{
    _x params ["_displayName", "_intercomChannel"];

    _actions pushBack [
        [
            format["TFAR_ExternalIntercomChannel_%1", _intercomChannel],
            _displayName,
            "",
            {
                params ["_vehicle", "_player", "_params"];
                _params params ["_intercomChannel", "_displayName"];

                if (!isNil "_vehicle") then {
                    _vehicle setVariable [format ["TFAR_IntercomSlot_%1",(netId _player)], _intercomChannel, true];
                    _player setVariable [format ["TFAR_IntercomSlot_%1",(netId _player)], _intercomChannel, true];
                };
            },
            {

                params ["_vehicle", "_player", "_params"];
                _params params ["_intercomChannel", "_displayName"];

                _intercom = _player getVariable [format ['TFAR_IntercomSlot_%1',(netID _player)], -2];

                if (!isNil "_vehicle" && _intercom isEqualTo -2) then {
                    _intercom = _vehicle getVariable ['TFAR_defaultIntercomSlot', TFAR_defaultIntercomSlot];
                };
                !(_intercom isEqualTo _intercomChannel)
            },
            {},
            [_intercomChannel, _displayName, _vehicle]
        ] call ace_interact_menu_fnc_createAction,
        [],
        _vehicle
    ];
} forEach _intercomChannels;

_actions;
