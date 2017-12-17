#include "script_component.hpp"

/*
    Name: TFAR_fnc_requestRadios

    Author(s):
        NKey
        L-H

    Description:
        Checks whether the player needs to have radios converted to "instanced" versions,
        handles waiting for response from server with radio classnames and applying them to the player.

    Parameters:
        BOOLEAN - Replace already instanced Radios

    Returns:
        Nothing

    Example:
        call TFAR_fnc_requestRadios;
*/

If (isDedicated) exitWith {
    ERROR("This function should never be called on a dedicated Server");
};

//#TODO somehow remove mutexing :x
//MUTEX_LOCK(TF_radio_request_mutex);
private _lastExec = GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_requestRadios_lastExec";
//If the loadout didn't change since last execute we don't need to check anything
//Also if player is still in Arsenal don't replace anything
if (_lastExec > TFAR_lastLoadoutChange  || GVAR(currentlyInArsenal)) exitWith {/*MUTEX_UNLOCK(TF_radio_request_mutex);*/};
GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_requestRadios_lastExec", diag_tickTime-0.1];

(_this call TFAR_fnc_radioToRequestCount) params ["_radiosToRequest", "_linkFirstItem"];

if (_radiosToRequest isEqualTo []) exitWith {/*MUTEX_UNLOCK(TF_radio_request_mutex);*/};

//#Deprecated radio classes
_radiosToRequest = _radiosToRequest apply {
    switch (_x) do {
        case "tf_anprc148jem" : {"TFAR_anprc148jem"}
        case "tf_anprc152" : {"TFAR_anprc152"};
        case "tf_anprc154" : {"TFAR_anprc154"};
        case "tf_fadak" : {"TFAR_fadak"};
        case "tf_pnr1000a" : {"TFAR_pnr1000a"};
        case "tf_rf7800str" : {"TFAR_rf7800str"};
        default {_x};
    };
};


//Answer EH
GVAR(lastRadioRequestEH_ID) = [
    "TFAR_RadioRequestResponseEvent",
    {
        params [["_response", [], [[]]]];
        if ((_response isEqualTo []) || {(_response select 0) isEqualTo "ERROR:47"}) exitWith {
            diag_log ["TFAR_ReceiveRadioRequestResponse", _response];
            hintC _response;
            call TFAR_fnc_hideHint;
            ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
            [[15, "radioRequest", round ((diag_tickTime-TFAR_beta_RadioRequestStart)*1000)]] call TFAR_fnc_betaTracker;//#TODO remove on release
        };
        _thisArgs params ["_radiosToReplace", "_linkFirstItem", "_requestedUnit"];

        If !(_thisId isEqualTo GVAR(lastRadioRequestEH_ID)) exitWith {
            ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
        };

        diag_log ["TFAR_ReceiveRadioRequestResponse", _response]; //#TODO remove on release

        private _newRadios = [];

        If (_linkFirstItem) then {
            private _OldItem = _radiosToReplace deleteAt 0;
            private _newID = _response deleteAt 0;

            If (_newID > 0) then {
                If (_OldItem == "ItemRadio") then {
                    _OldItem = (call TFAR_fnc_getDefaultRadioClasses) param [[2, 1] select ((TFAR_givePersonalRadioToRegularSoldier) or {leader _requestedUnit == _requestedUnit} or {rankId _requestedUnit >= 2}), ""];
                };
                private _NewItem = format["%1_%2", [_OldItem, "tf_parent", ""] call DFUNC(getWeaponConfigProperty), _newID];
                _requestedUnit linkItem _NewItem;

                _newRadios pushBack _NewItem;

                private _settings = _TF_SettingsToCopy deleteAt _index;
                if ([_NewItem, _OldItem] call TFAR_fnc_isSameRadio) then {
                    private _localSettings = TFAR_RadioSettingsNamespace getVariable (format["%1_local", _settings]);
                    if !(isNil "_localSettings") then {
                        [_NewItem, _OldItem, true] call TFAR_fnc_setSwSettings;
                    };
                };

            } else {
                _requestedUnit unassignItem _OldItem;
                _requestedUnit removeItem _OldItem;
            };
        };


        private _OldItem = _radiosToReplace deleteAt 0;
        {
            private _OldItem = _x;
            private _newID = _response deleteAt 0;

            _requestedUnit removeItem _OldItem;

            If (_OldItem == "ItemRadio") then {
                _OldItem = (call TFAR_fnc_getDefaultRadioClasses) param [[2, 1] select ((TFAR_givePersonalRadioToRegularSoldier) or {leader _requestedUnit == _requestedUnit} or {rankId _requestedUnit >= 2}), ""];
            };

            private _NewItem = format["%1_%2", [_OldItem, "tf_parent", ""] call DFUNC(getWeaponConfigProperty), _newID];

            If (_requestedUnit canAdd _NewItem) then {
                _requestedUnit AddItem _NewItem;
                _newRadios pushBack _NewItem;
            };

            private _settings = _TF_SettingsToCopy deleteAt _index;
            if ([_NewItem, _OldItem] call TFAR_fnc_isSameRadio) then {
                private _localSettings = TFAR_RadioSettingsNamespace getVariable (format["%1_local", _settings]);
                if !(isNil "_localSettings") then {
                    [_NewItem, _OldItem, true] call TFAR_fnc_setSwSettings;
                };
            };

            nil
        } count _radiosToReplace;


        call TFAR_fnc_hideHint;

        ["OnRadiosReceived", [_requestedUnit, _newRadios]] call TFAR_fnc_fireEventHandlers;

        ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
        [[15, "radioRequest", round ((diag_tickTime-TFAR_beta_RadioRequestStart)*1000)]] call TFAR_fnc_betaTracker;//#TODO remove on release
    },
    [_radiosToRequest, _linkFirstItem, TFAR_currentUnit]
] call CBA_fnc_addEventHandlerArgs;

[parseText(localize LSTRING(wait_radio)), 10] call TFAR_fnc_showHint;

TFAR_beta_RadioRequestStart = diag_tickTime;//#TODO remove on release
//Send request
diag_log ["TFAR_SendRadioRequest", _radiosToRequest, TF_respawnedAt,time];
["TFAR_RadioRequestEvent", [_radiosToRequest,TFAR_currentUnit]] call CBA_fnc_serverEvent;
//MUTEX_UNLOCK(TF_radio_request_mutex);
