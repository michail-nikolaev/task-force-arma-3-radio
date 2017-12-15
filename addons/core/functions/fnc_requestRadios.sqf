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

//#TODO somehow remove mutexing :x
//MUTEX_LOCK(TF_radio_request_mutex);
private _lastExec = GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_requestRadios_lastExec";
//If the loadout didn't change since last execute we don't need to check anything
//Also if player is still in Arsenal don't replace anything
if (_lastExec > TFAR_lastLoadoutChange  || GVAR(currentlyInArsenal)) exitWith {/*MUTEX_UNLOCK(TF_radio_request_mutex);*/};
GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_requestRadios_lastExec", diag_tickTime-0.1];

(_this call TFAR_fnc_radioToRequestCount) params ["_radiosToRequest","_TF_SettingsToCopy"];

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
[
    "TFAR_RadioRequestResponseEvent",
    {
        if !(params [["_response", [], [[]]]]) exitWith {
            diag_log ["TFAR_ReceiveRadioRequestResponse",_response];
            hintC _response;
            call TFAR_fnc_hideHint;
            ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
            [[15,"radioRequest",round ((diag_tickTime-TFAR_beta_RadioRequestStart)*1000)]] call TFAR_fnc_betaTracker;//#TODO remove on release
        };
        _thisArgs params ["_radiosToReplace", "_TF_SettingsToCopy", "_requestedUnit"];

        diag_log ["TFAR_ReceiveRadioRequestResponse",_response];

        private _fnc_CopySettings = {
            params ["_settingsCount", "_copyIndex", "_destination","_TF_SettingsToCopy"];

            if (_settingsCount > _copyIndex) then {
                if ([_destination, _TF_SettingsToCopy select _copyIndex] call TFAR_fnc_isSameRadio) then {
                    private _source = _TF_SettingsToCopy select _copyIndex;
                    private _variableName = format["%1_local", _source];
                    private _localSettings = TFAR_RadioSettingsNamespace getVariable _variableName;
                    if !(isNil "_variableName") then {
                        [_destination, _localSettings, true] call TFAR_fnc_setSwSettings;
                    };
                };
            };
            (_copyIndex + 1)
        };

        {
            if ((_x call TFAR_fnc_isRadio) || {_x == "ItemRadio"}) then {
                private _index = _radiosToReplace find _x;
                If (_index >= 0) then {
                    private _newRadioClass = _response deleteAt _index;
                    If (_newRadioClass isEqualTo "") then {
                        _requestedUnit unassignItem _x;
                        _requestedUnit removeItem _x;
                    } else {
                        _requestedUnit linkItem _newRadioClass;
                    };

                    _radiosToReplace deleteAt _index;
                    private _settings = _TF_SettingsToCopy deleteAt _index;
                    if ([_newRadioClass, _settings] call TFAR_fnc_isSameRadio) then {
                        private _localSettings = TFAR_RadioSettingsNamespace getVariable (format["%1_local", _settings]);
                        if !(isNil "_localSettings") then {
                            [_newRadioClass, _localSettings, true] call TFAR_fnc_setSwSettings;
                        };
                    };

                    [_newRadioClass, getPlayerUID player, true] call TFAR_fnc_setRadioOwner;
                };
            };
            nil
        } count (assignedItems _requestedUnit);

        private _allItems = ((getItemCargo (uniformContainer TFAR_currentUnit)) select 0);
        _allItems append ((getItemCargo (vestContainer TFAR_currentUnit)) select 0);
        _allItems append ((getItemCargo (backpackContainer TFAR_currentUnit)) select 0);

        {
            
            if (_radiosToReplace isEqualTo []) exitWith {};

            if ((_x call TFAR_fnc_isRadio) || {_x == "ItemRadio"}) then {
                private _index = _radiosToReplace find _x;
                If (_index >= 0) then {
                    private _newRadioClass = _response deleteAt _index;

                    _requestedUnit removeItem _x;
                    If (_requestedUnit canAdd _newRadioClass) then {
                        _requestedUnit addItem _newRadioClass;
                    };

                    _radiosToReplace deleteAt _index;
                    private _settings = _TF_SettingsToCopy deleteAt _index;
                    if ([_newRadioClass, _settings] call TFAR_fnc_isSameRadio) then {
                        private _localSettings = TFAR_RadioSettingsNamespace getVariable (format["%1_local", _settings]);
                        if !(isNil "_localSettings") then {
                            [_newRadioClass, _localSettings, true] call TFAR_fnc_setSwSettings;
                        };
                    };

                    [_newRadioClass, getPlayerUID player, true] call TFAR_fnc_setRadioOwner;
                };
            };
            nil
        } count _allItems;


        call TFAR_fnc_hideHint;

        ["OnRadiosReceived", [TFAR_currentUnit, _response]] call TFAR_fnc_fireEventHandlers;

        ["TFAR_RadioRequestResponseEvent", _thisId] call CBA_fnc_removeEventHandler;
        [[15,"radioRequest",round ((diag_tickTime-TFAR_beta_RadioRequestStart)*1000)]] call TFAR_fnc_betaTracker;//#TODO remove on release
    },
    [_radiosToRequest, _TF_SettingsToCopy, TFAR_currentUnit]
] call CBA_fnc_addEventHandlerArgs;

[parseText(localize LSTRING(wait_radio)), 10] call TFAR_fnc_showHint;

// after the settings are initialized, we can replace the itemradio with the default class
If (GVAR(SettingsInitialized)) then {
    private _classes = call TFAR_fnc_getDefaultRadioClasses;
    private _personalRadio = _classes select 1;
    private _riflemanRadio = _classes select 2;
    private _defaultRadio = _riflemanRadio;

    if ((TFAR_givePersonalRadioToRegularSoldier) or {leader TFAR_currentUnit == TFAR_currentUnit} or {rankId TFAR_currentUnit >= 2}) then {
        _defaultRadio = _personalRadio;
    };

    _radiosToRequest = _radiosToRequest apply {If (_x == "ItemRadio") then {_defaultRadio} else {_x}};
};



TFAR_beta_RadioRequestStart = diag_tickTime;//#TODO remove on release
//Send request
diag_log ["TFAR_SendRadioRequest",_radiosToRequest,TF_respawnedAt,time];
["TFAR_RadioRequestEvent", [_radiosToRequest,TFAR_currentUnit]] call CBA_fnc_serverEvent;
//MUTEX_UNLOCK(TF_radio_request_mutex);
