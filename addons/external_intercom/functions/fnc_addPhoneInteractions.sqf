#include "script_component.hpp"

/*
    Name: TFAR_external_intercom_fnc_addPhoneInteractions

    Author: Arend(Saborknight)
        Disconnects the player from the intercom of a vehicle.    

    Arguments:
        0: frequencies input <STRING>

    Return Value:
        cleaned input <STRING>

    Example:
        ["123 123 , 332 23"] call TFAR_external_intercom_fnc_addPhoneInteractions;

    Public: No
*/
params ["_vehicle"];

if (([typeOf _vehicle, 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) isEqualTo 0 || !alive _vehicle || (_vehicle getVariable [QGVAR(phoneInteractionsSet), false])) exitWith {"no"};

#define ADD_TO_CLASS [_vehicle, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

_action = [
    QGVAR(phoneConnect),
    localize LSTRING(PICKUP_PHONE),
    QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone.paa),
    {_this call TFAR_external_intercom_fnc_connect},
    {
        params ["_vehicle", "_player"];
        alive _vehicle && (
            (
                (_vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 0) isEqualTo objNull
                && TFAR_externalIntercomEnable isEqualTo 0
            ) || (
                (_vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 0) isEqualTo objNull
                && [side _player, side _vehicle] call BIS_fnc_sideIsFriendly
                && TFAR_externalIntercomEnable isEqualTo 1
            )
        )
    },
    {},
    [],
    {[_this select 0] call TFAR_external_intercom_fnc_getInteractionPoint}
] call ace_interact_menu_fnc_createAction;

ADD_TO_CLASS

_action = [
    QGVAR(phoneDisconnect),
    localize LSTRING(PUT_AWAY_PHONE),
    QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone.paa),
    {_this call TFAR_external_intercom_fnc_disconnect},
    {
        params ["_vehicle", "_player"];
        alive _vehicle
        && (_vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 0) isEqualTo _player
    },
    {_this call TFAR_external_intercom_fnc_addIntercomChannels},
    [],
    {[_this select 0] call TFAR_external_intercom_fnc_getInteractionPoint}
] call ace_interact_menu_fnc_createAction;

ADD_TO_CLASS

_action = [
    QGVAR(phoneBusy),
    localize LSTRING(PHONE_BUSY),
    QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone_busy.paa),
    {},
    {
        params ["_vehicle", "_player"];
        _vehiclePhoneSpeaker = _vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]] select 0;
        alive _vehicle && !isNull _vehiclePhoneSpeaker && !(_vehiclePhoneSpeaker isEqualTo _player)
    },
    {},
    [],
    {[_this select 0] call TFAR_external_intercom_fnc_getInteractionPoint}
] call ace_interact_menu_fnc_createAction;

ADD_TO_CLASS

_vehicle setVariable [QGVAR(phoneInteractionsSet), true];
