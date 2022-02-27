#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_addWirelessIntercomMenu

  Author: Arend(Saborknight)
    Adds ACE self-interact actions for the wireless intercom and all the
    intercom channels from the target vehicle as children to the current
    interaction menu parent.

  Arguments:
    0: Target vehicle <OBJECT>
    1: Player <OBJECT>

  Return Value:
    ACE Self-Actions of the Wireless controls to insert as children <ARRAY>

  Example:
    [_target, _player] call TFAR_external_intercom_fnc_addWirelessIntercomMenu;

  Public: Yes
*/
params ["_target", "_player"];

_vehicle = _player getVariable "TFAR_ExternalIntercomVehicle";

if (isNil "_vehicle") exitWith {[]};

private _actions = [];

_actions pushBack [
    [
        format ["TFAR_External_Intercom_Wireless_Disconnect", _intercomChannel],
        localize LSTRING(DISCONNECT_WIRELESS),
        QPATHTOF(ui\tfar_ace_interaction_external_intercom_wireless_disconnect.paa),
        {
            params ["", "_player"];
            [_player getVariable 'TFAR_ExternalIntercomVehicle', _player] call TFAR_external_intercom_fnc_disconnect;
        },
        {
            params ["", "_player"];
           !isNil {_player getVariable 'TFAR_ExternalIntercomVehicle'}
            && (_player getVariable ['TFAR_ExternalIntercomVehicle', objNull]) getVariable ['TFAR_ExternalIntercomSpeakers', [objNull, []]] select 1 find _player > -1;
        }
    ] call ace_interact_menu_fnc_createAction,
    [],
    _vehicle
];

_actions pushBack [
    [
        format ["TFAR_External_Intercom_Wireless_Channels", _intercomChannel],
        localize ELSTRING(Core,Intercom_ACESelfAction_Name),
        "",
        {},
        {
            params ["", "_player"];
           !isNil {_player getVariable 'TFAR_ExternalIntercomVehicle'}
            && (_player getVariable ['TFAR_ExternalIntercomVehicle', objNull]) getVariable ['TFAR_ExternalIntercomSpeakers', [objNull, []]] select 1 find _player > -1;
        },
        {call TFAR_external_intercom_fnc_addIntercomChannels;}
    ] call ace_interact_menu_fnc_createAction,
    [],
    _vehicle
];

_actions;
