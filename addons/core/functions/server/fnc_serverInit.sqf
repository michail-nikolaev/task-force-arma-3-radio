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

missionNamespace setVariable ["TF_server_addon_version",TFAR_ADDON_VERSION,true];

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


//Handle API variables

if (!isNil "TFAR_defaultFrequencies_sr_west") then {
    TFAR_SameSRFrequenciesForSide = true;
    TFAR_freq_sr_west = call TFAR_fnc_generateSRSettings;
    TFAR_freq_sr_west set [2,TFAR_defaultFrequencies_sw_west];
};

if (!isNil "TFAR_defaultFrequencies_sr_east") then {
    TFAR_SameSRFrequenciesForSide = true;
    TFAR_freq_sr_east = call TFAR_fnc_generateSRSettings;
    TFAR_freq_sr_east set [2,TFAR_defaultFrequencies_sw_west];
};

if (!isNil "TFAR_defaultFrequencies_sr_independent") then {
    TFAR_SameSRFrequenciesForSide = true;
    TFAR_freq_sr_independent = call TFAR_fnc_generateSRSettings;
    TFAR_freq_sr_independent set [2,TFAR_defaultFrequencies_sw_west];
};

if (!isNil "TFAR_defaultFrequencies_lr_west") then {
    TFAR_SameLRFrequenciesForSide = true;
    TFAR_freq_lr_west = call TFAR_fnc_generateLrSettings;
    TFAR_freq_lr_west set [2,TFAR_defaultFrequencies_lr_west];
};

if (!isNil "TFAR_defaultFrequencies_lr_east") then {
    TFAR_SameLRFrequenciesForSide = true;
    TFAR_freq_lr_east = call TFAR_fnc_generateLrSettings;
    TFAR_freq_lr_east set [2,TFAR_defaultFrequencies_lr_east];
};

if (!isNil "TFAR_defaultFrequencies_lr_independent") then {
    TFAR_SameLRFrequenciesForSide = true;
    TFAR_freq_lr_independent = call TFAR_fnc_generateLrSettings;
    TFAR_freq_lr_independent set [2,TFAR_defaultFrequencies_lr_independent];
};






//Default variables

VARIABLE_DEFAULT(tf_same_sw_frequencies_for_side,false);
VARIABLE_DEFAULT(tf_same_lr_frequencies_for_side,true);
VARIABLE_DEFAULT(tf_same_dd_frequencies_for_side,true);

VARIABLE_DEFAULT(tf_freq_west,call TFAR_fnc_generateSRSettings);
VARIABLE_DEFAULT(tf_freq_east,call TFAR_fnc_generateSRSettings);
VARIABLE_DEFAULT(tf_freq_guer,call TFAR_fnc_generateSRSettings);

VARIABLE_DEFAULT(tf_freq_west_lr,call TFAR_fnc_generateLrSettings);
VARIABLE_DEFAULT(tf_freq_east_lr,call TFAR_fnc_generateLrSettings);
VARIABLE_DEFAULT(tf_freq_guer_lr,call TFAR_fnc_generateLrSettings);

VARIABLE_DEFAULT(tf_freq_west_dd,call TFAR_fnc_generateDDFreq);
VARIABLE_DEFAULT(tf_freq_east_dd,call TFAR_fnc_generateDDFreq);
VARIABLE_DEFAULT(tf_freq_guer_dd,call TFAR_fnc_generateDDFreq);





while {true} do {
    call TFAR_fnc_processGroupFrequencySettings;
    private _allUnits = allUnits;
    {
        _allUnits pushBack _x;
        true;
    } count (call BIS_fnc_listCuratorPlayers);

    {
        if (isPlayer _x) then {

            private _ModActive = _x getVariable "TFAR_modActive";
            _variableName = "no_radio_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
            if (isNil "_ModActive") then {
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
