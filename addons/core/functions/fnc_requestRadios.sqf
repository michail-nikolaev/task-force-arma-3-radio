#include "script_component.hpp"

/*
  Name: TFAR_fnc_requestRadios

  Author: NKey, Garth de Wet (L-H)
    Checks whether the player needs to have radios converted to "instanced" versions,
    handles waiting for response from server with radio classnames and applying them to the player.

  Arguments:
    0: Replace already instanced Radios <BOOL>

  Return Value:
    None

  Example:
    call TFAR_fnc_requestRadios;

  Public: Yes
*/

if (isDedicated) exitWith {
    ERROR("This function should never be called on a dedicated Server");
};

private _lastExec = GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_requestRadios_lastExec";
//If the loadout didn't change since last execute we don't need to check anything
//Also if player is still in Arsenal don't replace anything
if (_lastExec > TFAR_lastLoadoutChange  || GVAR(currentlyInArsenal)) exitWith {};
GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_requestRadios_lastExec", diag_tickTime-0.1];

(_this call TFAR_fnc_radioToRequestCount) params ["_radiosToRequest", "_settingsToCopy", "_linkFirstItem"];

if (_radiosToRequest isEqualTo []) exitWith {};

//#Deprecated radio classes
_radiosToRequest = _radiosToRequest apply {
    switch (_x) do {
        case "tf_anprc148jem" : {"TFAR_anprc148jem"};
        case "tf_anprc152" : {"TFAR_anprc152"};
        case "tf_anprc154" : {"TFAR_anprc154"};
        case "tf_fadak" : {"TFAR_fadak"};
        case "tf_pnr1000a" : {"TFAR_pnr1000a"};
        case "tf_rf7800str" : {"TFAR_rf7800str"};
        default {_x};
    };
};


//Answer EH. The server sent us instanciated radios
GVAR(lastRadioRequestEH_ID) = [
    "TFAR_RadioRequestResponseEvent", {

        params [["_response", [], [[]]]];
        if ((_response isEqualTo []) || {(_response select 0) isEqualTo "ERROR:47"}) exitWith {
            diag_log ["TFAR_ReceiveRadioRequestResponse", _response];
            hintC _response;
            call TFAR_fnc_hideHint;
            ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
            [[15, "radioRequest", round ((diag_tickTime-TFAR_beta_RadioRequestStart)*1000)]] call TFAR_fnc_betaTracker;//#TODO remove on release
        };

        _thisArgs params ["_radiosToReplace", "_linkFirstItem", "_settingsToCopy", "_requestedUnit"];

        //Got a outdated result
        if !(_thisId isEqualTo GVAR(lastRadioRequestEH_ID)) exitWith {
            ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
            //#TODO this should be handled like an error. If this happens the server will discard unique IDs and we only have a limited number of them
            //I don't really want a garbage collection system like ACRE. TFAR's system is enough if we take some care not to throw away IDs.
        };

        diag_log ["TFAR_ReceiveRadioRequestResponse", _response]; //#TODO remove on release

        private _newRadios = [];

        if (_linkFirstItem) then {
            private _oldItem = _radiosToReplace deleteAt 0;
            private _newID = _response deleteAt 0;

            if (_newID > 0) then {
                if (_oldItem == "ItemRadio") then {
                    _oldItem = (TFAR_currentUnit call TFAR_fnc_getDefaultRadioClasses) param [[2, 1] select ((TFAR_givePersonalRadioToRegularSoldier) || {leader _requestedUnit == _requestedUnit} || {rankId _requestedUnit >= 2}), ""];
                };
                private _newItem = format["%1_%2", [_oldItem, "tf_parent", ""] call DFUNC(getWeaponConfigProperty), _newID];

                _requestedUnit linkItem _newItem;
                _newRadios pushBack _newItem;

                private _settings = _settingsToCopy param [_settingsToCopy find _oldItem, objNull];
                if (!isNull _settings) then {
                    private _localSettings = TFAR_RadioSettingsNamespace getVariable (format["%1_local", _settings]);
                    if !(isNil "_localSettings") then {
                        [_newItem, _localSettings, true] call TFAR_fnc_setSwSettings;
                    };
                };

            } else {
                _requestedUnit unassignItem _oldItem;
                _requestedUnit removeItem _oldItem;
            };
        };


        private _oldItem = _radiosToReplace deleteAt 0;
        {
            private _oldItem = _x;
            private _newID = _response deleteAt 0;

            _requestedUnit removeItem _oldItem;

            if (_oldItem == "ItemRadio") then {
                _oldItem = (TFAR_currentUnit call TFAR_fnc_getDefaultRadioClasses) param [[2, 1] select ((TFAR_givePersonalRadioToRegularSoldier) or {leader _requestedUnit == _requestedUnit} or {rankId _requestedUnit >= 2}), ""];
            };

            private _newItem = format["%1_%2", [_oldItem, "tf_parent", ""] call DFUNC(getWeaponConfigProperty), _newID];

            if (_requestedUnit canAdd _newItem) then {
                _requestedUnit addItem _newItem;
                _newRadios pushBack _newItem;
            };

            private _settings = _settingsToCopy param [_settingsToCopy find _oldItem, objNull];
            if (!isNull _settings) then {
                private _localSettings = TFAR_RadioSettingsNamespace getVariable (format["%1_local", _settings]);
                if !(isNil "_localSettings") then {
                    [_newItem, _localSettings, true] call TFAR_fnc_setSwSettings;
                };
            };
        } forEach _radiosToReplace;


        call TFAR_fnc_hideHint;

        ["OnRadiosReceived", [_requestedUnit, _newRadios]] call TFAR_fnc_fireEventHandlers;

        ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
        [[15, "radioRequest", round ((diag_tickTime-TFAR_beta_RadioRequestStart)*1000)]] call TFAR_fnc_betaTracker;//#TODO remove on release
    }, [_radiosToRequest, _linkFirstItem, _settingsToCopy, TFAR_currentUnit]
] call CBA_fnc_addEventHandlerArgs;

[parseText(localize LSTRING(wait_radio)), 10] call TFAR_fnc_showHint;

TFAR_beta_RadioRequestStart = diag_tickTime;//#TODO remove on release
//Send request
diag_log ["TFAR_SendRadioRequest", _radiosToRequest, TF_respawnedAt,time];
["TFAR_RadioRequestEvent", [_radiosToRequest,TFAR_currentUnit]] call CBA_fnc_serverEvent;
//MUTEX_UNLOCK(TF_radio_request_mutex);
