#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_addWirelessInteractions

  Author: Arend(Saborknight)
    Adds ACE interactions for the wireless intercom.

  Arguments:
    0: Vehicle object <OBJECT>

  Return Value:
    None

  Example:
    [vehicle player] call TFAR_external_intercom_fnc_addWirelessInteractions;

  Public: No
*/
params ["_vehicle"];

if (([typeOf _vehicle, 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) isEqualTo 0 || !alive _vehicle || (_vehicle getVariable [QGVAR(wirelessInteractionsSet), false])) exitWith {"no"};

#define ADD_TO_OBJECT [_vehicle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject

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

ADD_TO_OBJECT;

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

ADD_TO_OBJECT;

_vehicle setVariable [QGVAR(wirelessInteractionsSet), true];
