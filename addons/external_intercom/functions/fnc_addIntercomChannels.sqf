#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_addIntercomChannels

  Author: Arend(Saborknight)
    Adds all the intercom channels from the target vehicle as children to the
    current interaction menu parent.

  Arguments:
    0: Vehicle object <OBJECT>
    1: Player unit <OBJECT>
    2: Params <ARRAY>

  Return Value:
    ACE Actions of the Intercom Channels to insert as children <ARRAY>

  Example:
    call TFAR_external_intercom_fnc_addIntercomChannels;

  Public: Yes
*/
params ["_target", "_player", "_params"];

_vehicle = _player getVariable "TFAR_ExternalIntercomVehicle";
private _intercomRootClass = configFile >> "CfgVehicles" >> typeOf _vehicle >> "ACE_SelfActions" >> "TFAR_IntercomChannel";
private _intercomChannels = (_intercomRootClass) call BIS_fnc_getCfgSubClasses;
private _channelId = -1;
private _searchTerm = "ACE_Player)],";
private _statement = "";

_intercomChannels = _intercomChannels apply {
    _statement = getText(_intercomRootClass >> _x >> "statement");
    // Since we're dealing with unpredictable developers, search a string of 5
    // characters then filter out anything non-numeric but include negative (-)
    _channelId = parseNumber ([_statement select [((_statement find _searchTerm) + count _searchTerm),5], "-0123456789"] call BIS_fnc_filterString);
    [getText(_intercomRootClass >> _x >> "displayName"), _channelId];
};

if (_intercomChannels isEqualTo []) exitWith {false};

private _actions = [];

{
    _x params ["_displayName", "_intercomChannel"];

    _actions pushBack [
        [
            format ["TFAR_ExternalIntercomChannel_%1", _intercomChannel],
            _displayName,
            "",
            {
                params ["_vehicle", "_player", "_params"];
                _params params ["_intercomChannel", "_displayName"];

                if (!isNil "_vehicle") then {
                    _vehicle setVariable [format ["TFAR_IntercomSlot_%1", (netId _player)], _intercomChannel, true];
                    _player setVariable [format ["TFAR_IntercomSlot_%1", (netId _player)], _intercomChannel, true];
                };
            },
            {!isNil {_this select 0}}, // Vehicle is not nil
            {},
            [_intercomChannel, _displayName, _vehicle],
            {[0,0,0]},
            4,
            [false,false,false,false,false],
            {
                params ["_vehicle", "_player", "_args", "_actionData"];
                _args params ["_intercomChannel", "_displayName"];

                _intercom = _player getVariable [format ['TFAR_IntercomSlot_%1', (netID _player)], -2];

                if (_intercom isEqualTo -2) then {
                    _intercom = _vehicle getVariable ['TFAR_defaultIntercomSlot', TFAR_defaultIntercomSlot];
                };

                if (_intercom isEqualTo _intercomChannel) then {
                    _actionData set [2, ""];
                } else {
                    _actionData set [2, ["", "#909090"]];
                };
            }
        ] call ace_interact_menu_fnc_createAction,
        [],
        _vehicle
    ];
} forEach _intercomChannels;

_actions;
