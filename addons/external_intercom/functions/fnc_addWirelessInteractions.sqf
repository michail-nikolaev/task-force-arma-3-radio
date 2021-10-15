#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_addWirelessInteractions

  Author: Arend(Saborknight)
    Disconnects the player from the intercom of a vehicle.

  Arguments:
    0: frequencies input <STRING>

  Return Value:
    cleaned input <STRING>

  Example:
    ["123 123 , 332 23"] call TFAR_external_intercom_fnc_addWirelessInteractions;

  Public: No
*/
params ["_vehicle"];

if (([typeOf _vehicle, 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) isEqualTo 0 || !alive _vehicle) exitWith {"no"};

#define ADD_TO_CLASS [typeOf _vehicle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = [
    QGVAR(wirelessConnect),
    localize LSTRING(CONNECT_WIRELESS),
    QPATHTOF(ui\tfar_ace_interaction_external_intercom_wireless.paa),
    {_this set [2, [true]]; _this call TFAR_external_intercom_fnc_connect},
    {
        params ["_vehicle", "_player"];
        alive _target
        && (
            (
                !(_player in (_target getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 1))
                && [_player] call FUNC(hasWirelessHeadgear)
                && TFAR_externalIntercomEnable isEqualTo 0
             ) || (
                !(_player in (_target getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 1))
                && [_player] call FUNC(hasWirelessHeadgear)
                && [side _player, side _target] call BIS_fnc_sideIsFriendly
                && TFAR_externalIntercomEnable isEqualTo 1
            )
        )
    }
] call ace_interact_menu_fnc_createAction;

ADD_TO_CLASS

_action = [
    QGVAR(wirelessDisconnect),
    localize LSTRING(DISCONNECT_WIRELESS),
    QPATHTOF(ui\tfar_ace_interaction_external_intercom_wireless_disconnect.paa),
    {_this call TFAR_external_intercom_fnc_disconnect},
    {
        params ["_vehicle", "_player"];
        alive _vehicle
        && _player in (_vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 1)
    }
] call ace_interact_menu_fnc_createAction;

ADD_TO_CLASS
