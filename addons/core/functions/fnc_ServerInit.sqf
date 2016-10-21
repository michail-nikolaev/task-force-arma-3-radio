#include "script_component.hpp"

/*
    Name: TFAR_fnc_serverInit

    Author(s):
        NKey
        L-H

    Description:
        Initialises the server and the server loop.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_serverInit;
*/

TF_server_addon_version = TFAR_ADDON_VERSION;
publicVariable "TF_server_addon_version";

waitUntil {sleep 0.1;time > 0};

TFAR_RadioCountHash = [] call CBA_fnc_hashCreate;

["TFAR_RadioRequestEvent", {
    diag_log format["TFAR_RadioRequestEvent %1 %2",_this,diag_tickTime];//#TODO remove
    params [["_radio_request",[]],"_player"];
    private _response = [];
    if (_radio_request isEqualType []) then {
        {
            _x params ["_radioBaseClass"];
            //get Radio baseclass without ID
            if !(_radioBaseClass call TFAR_fnc_isPrototypeRadio) then {
                _radioBaseClass = getText (configFile >> "CfgWeapons" >> _radioBaseClass >> "tf_parent");
            };

            private _nextRadioIndex = 1;
            if ([TFAR_RadioCountHash,_radioBaseClass] call CBA_fnc_hashHasKey) then {
                //Baseclass already exists so increment its current Index
                private _currentRadioIndex = [TFAR_RadioCountHash,_radioBaseClass] call CBA_fnc_hashGet;

                if (_currentRadioIndex > MAX_RADIO_COUNT) then {
                    //If too big go to 1 again. Could cause duplicate Radios if you really have >MAX_RADIO_COUNT active radios
                    _nextRadioIndex = 1;
                } else {
                    //Increment Index and return in _nextRadioIndex
                    _nextRadioIndex = _currentRadioIndex + 1;
                };
            };
            //This will either set the new Index or add an entry with Index 1
            [TFAR_RadioCountHash,_radioBaseClass,_nextRadioIndex] call CBA_fnc_hashSet;

            _response pushBack format["%1_%2", _radioBaseClass, _nextRadioIndex];//form new classname of baseclass_ID
            true;
        } count _radio_request;
    } else {
        _response = "ERROR:47";
        diag_log format ["TFAR - ERROR:47 - Request Content: %1; Requested By: %2", _radio_reqest, _player];
    };
    diag_log format["Send TFAR_RadioRequestResponseEvent %1 %2",_response,diag_tickTime];//#TODO remove
    //Answer request _response is an array of ["baseclass_ID","baseclass_ID"] of all radios requested
    ["TFAR_RadioRequestResponseEvent", [_response], _player] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

















while {true} do {
    call TFAR_fnc_processGroupFrequencySettings;
    private _allUnits = allUnits;
    {
        _allUnits pushBack _x;
        true;
    } count (call BIS_fnc_listCuratorPlayers);

    {
        if (isPlayer _x) then {

            private _task_force_radio_used = _x getVariable "TFAR_modActive";
            _variableName = "no_radio_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
            if (isNil "_task_force_radio_used") then {
                private _last_check = missionNamespace getVariable _variableName;

                if (isNil "_last_check") then {
                    missionNamespace setVariable [_variableName, time];
                } else {
                    if (time - _last_check > 30) then {
                        [["LOOKS LIKE TASK FORCE RADIO ADDON NOT ENABLED OR VERSION LESS THAN 0.8.1"],"BIS_fnc_guiMessage",(owner _x), false] spawn BIS_fnc_MP;
                        _x setVariable ["TFAR_modActive", "error_shown", true];
                    };
                };
            } else {
                missionNamespace setVariable [_variableName, nil];
            };
        };
    } count _allUnits;
    sleep 1;
};
