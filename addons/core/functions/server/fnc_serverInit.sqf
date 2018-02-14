#include "script_component.hpp"

/*
  Name: TFAR_fnc_serverInit

  Author: NKey, Garth de Wet (L-H)
    Initialises the server and the server loop.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_serverInit;

  Public: No
*/

["TFAR_RadioRequestEvent", {
    diag_log format["TFAR_RadioRequestEvent %1 %2",_this,diag_tickTime];//#TODO remove
    params [["_radio_request",[]],"_player"];
    private _response = [];
    if (_radio_request isEqualType []) then {
        _response = (_radio_request call TFAR_fnc_instanciateRadios);
    } else {
        _response = "ERROR:47";
        diag_log format ["TFAR - ERROR:47 - Request Content: %1; Requested By: %2", _radio_reqest, _player];
    };
    diag_log format["Send TFAR_RadioRequestResponseEvent %1 %2",_response,diag_tickTime];//#TODO remove
    //Answer request _response is an array of ["baseclass_ID","baseclass_ID"] of all radios requested
    ["TFAR_RadioRequestResponseEvent", [_response], _player] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;


//Handle API variables

//Deprecated ones first.
DEPRECATE_VARIABLE(tf_same_sw_frequencies_for_side,TFAR_SameSRFrequenciesForSide);
DEPRECATE_VARIABLE(tf_same_lr_frequencies_for_side,TFAR_SameLRFrequenciesForSide);

if (!isNil "tf_freq_west") then { \
    WARNING('Deprecated variable used: tf_freq_west (new: TFAR_defaultFrequencies_sr_west) in ADDON'); \
    TFAR_defaultFrequencies_sr_west = tf_freq_west param [2,nil];
};
if (!isNil "tf_freq_west_lr") then { \
    WARNING('Deprecated variable used: tf_freq_west_lr (new: TFAR_defaultFrequencies_lr_west) in ADDON'); \
    TFAR_defaultFrequencies_lr_west = tf_freq_west_lr param [2,nil];
};

if (!isNil "tf_freq_east") then { \
    WARNING('Deprecated variable used: tf_freq_east (new: TFAR_defaultFrequencies_sr_east) in ADDON'); \
    TFAR_defaultFrequencies_sr_east = tf_freq_east param [2,nil];
};
if (!isNil "tf_freq_east_lr") then { \
    WARNING('Deprecated variable used: tf_freq_east_lr (new: TFAR_defaultFrequencies_lr_east) in ADDON'); \
    TFAR_defaultFrequencies_lr_east = tf_freq_east_lr param [2,nil];
};

if (!isNil "tf_freq_guer") then { \
    WARNING('Deprecated variable used: tf_freq_guer (new: TFAR_defaultFrequencies_sr_independent) in ADDON'); \
    TFAR_defaultFrequencies_sr_independent = tf_freq_guer param [2,nil];
};
if (!isNil "tf_freq_guer_lr") then { \
    WARNING('Deprecated variable used: tf_freq_guer_lr (new: TFAR_defaultFrequencies_lr_independent) in ADDON'); \
    TFAR_defaultFrequencies_lr_independent = tf_freq_guer_lr param [2,nil];
};

if (TFAR_SameSRFrequenciesForSide) then {
    TFAR_freq_sr_west = false call DFUNC(generateSRSettings);
    TFAR_freq_sr_west set [2,TFAR_defaultFrequencies_sr_west];
    TFAR_freq_sr_east = false call DFUNC(generateSRSettings);
    TFAR_freq_sr_east set [2,TFAR_defaultFrequencies_sr_east];
    TFAR_freq_sr_independent = false call DFUNC(generateSRSettings);
    TFAR_freq_sr_independent set [2,TFAR_defaultFrequencies_sr_independent];
    publicVariable "TFAR_freq_sr_west";
    publicVariable "TFAR_freq_sr_east";
    publicVariable "TFAR_freq_sr_independent";
} else {
    VARIABLE_DEFAULT(TFAR_freq_sr_west,true call DFUNC(generateSRSettings));
    VARIABLE_DEFAULT(TFAR_freq_sr_east,true call DFUNC(generateSRSettings));
    VARIABLE_DEFAULT(TFAR_freq_sr_independent,true call DFUNC(generateSRSettings));
};

if (TFAR_SameLRFrequenciesForSide) then {
    TFAR_freq_lr_west = false call DFUNC(generateLrSettings);
    TFAR_freq_lr_west set [2,TFAR_defaultFrequencies_lr_west];
    TFAR_freq_lr_east = false call DFUNC(generateLrSettings);
    TFAR_freq_lr_east set [2,TFAR_defaultFrequencies_lr_east];
    TFAR_freq_lr_independent = false call DFUNC(generateLrSettings);
    TFAR_freq_lr_independent set [2,TFAR_defaultFrequencies_lr_independent];
    publicVariable "TFAR_freq_lr_west";
    publicVariable "TFAR_freq_lr_east";
    publicVariable "TFAR_freq_lr_independent";
} else {
    VARIABLE_DEFAULT(TFAR_freq_lr_west,true call DFUNC(generateLrSettings));
    VARIABLE_DEFAULT(TFAR_freq_lr_east,true call DFUNC(generateLrSettings));
    VARIABLE_DEFAULT(TFAR_freq_lr_independent,true call DFUNC(generateLrSettings));
};

//Check if all players are running TFAR
{
    if(isServer) exitWith {};
    waitUntil {sleep 0.1;time > 3};
    if !(isClass(configFile >> "CfgPatches" >> "tfar_core")) exitWith {
        [player, localize LSTRING(WM_NotLoad)] remoteExec ["globalChat", -2];
        if (isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam", objNull])) then {
            [localize LSTRING(WM_NotLoad_Desc)] call "BIS_fnc_guiMessage";
        };
    };
} remoteExec ["BIS_fnc_spawn", -2, true];
