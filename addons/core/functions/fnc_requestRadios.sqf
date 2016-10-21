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
        spawn TFAR_fnc_requestRadios;
*/

private _fnc_CopySettings = {
    params ["_settingsCount", "_copyIndex", "_destination"];

    if (_settingsCount > _copyIndex) then {
        if ([_destination, TF_settingsToCopy select _copyIndex] call TFAR_fnc_isSameRadio) then {
            private _source = TF_settingsToCopy select _copyIndex;
            private _variableName = format["%1_settings_local", _source];
            private _localSettings = missionNamespace getVariable _variableName;
            if !(isNil "_variableName") then {
                [_destination, _localSettings, true] call TFAR_fnc_setSwSettings;
            };
        };
    };
    (_copyIndex + 1)
};

waitUntil {
    if (!TF_radio_request_mutex) exitWith {TF_radio_request_mutex = true; true};
    false;
};

if ((time - TF_last_request_time > 3) or {_this}) then {
    TF_last_request_time = time;
    private _radiosToRequest = _this call TFAR_fnc_radioToRequestCount;

    if ((count _radiosToRequest) > 0) then {
        //Send request
        diag_log format["Send TFAR_RadioRequestEvent %1 %2",[_radiosToRequest,player],diag_tickTime]; //#TODO remove
        ["TFAR_RadioRequestEvent", [_radiosToRequest,player]] call CBA_fnc_serverEvent;

        [parseText(localize ("STR_wait_radio")), 10] call TFAR_fnc_ShowHint;

        //Wait for answer
        ["TFAR_RadioRequestResponseEvent", {
            diag_log format["TFAR_RadioRequestResponseEvent %1 %2",_this,diag_tickTime];//#TODO remove
            params ["_response"];
            private _copyIndex = 0;
            if (_response isEqualType []) then {
                private _radioCount = count _response;
                private _settingsCount = count TF_SettingsToCopy;
                private _startIndex = 0;
                if (_radioCount > 0) then {
                    if (TF_first_radio_request) then {
                        TF_first_radio_request = false;
                        TFAR_currentUnit linkItem (_response select 0);
                        _copyIndex = [_settingsCount, _copyIndex, (_response select 0)] call _fnc_CopySettings;
                        [(_response select 0), getPlayerUID player, true] call TFAR_fnc_setRadioOwner;
                        _startIndex = 1;
                    };
                    _radioCount = _radioCount - 1;
                    for "_index" from _startIndex to _radioCount do {
                        TFAR_currentUnit addItem (_response select _index);
                        _copyIndex = [_settingsCount, _copyIndex, (_response select _index)] call _fnc_CopySettings;
                        [(_response select _index), getPlayerUID player, true] call TFAR_fnc_setRadioOwner;
                    };
                };
            } else {
                hintC _response;
            };
            call TFAR_fnc_HideHint;
            //								unit, radios
            ["OnRadiosReceived", [TFAR_currentUnit, _response]] call TFAR_fnc_fireEventHandlers;

            ["TFAR_RadioRequestResponseEvent", _eventId] call CBA_fnc_removeEventHandler;
        }] call CBA_fnc_addEventHandler;



    };
    TF_last_request_time = time;
};
TF_radio_request_mutex = false;
