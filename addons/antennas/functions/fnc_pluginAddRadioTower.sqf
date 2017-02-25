#include "script_component.hpp"

/*
    Name: TFAR_antennas_fnc_pluginAddRadioTower

    Author(s):
        Dedmen

    Description:
        Tells Teamspeak that there is a new Tower
        Performancewise it's best to collect towers and pass multiple in one call.

    Parameters:
        ARRAY:
            OBJECT: the Tower

    Returns:
        NOTHING

    Example:
        [_tower1,_tower2] call TFAR_fnc_pluginAddRadioTower;
*/

//params get's weird with array Input so I just don't use it.
diag_log ["TFAR_antennas_fnc_pluginAddRadioTower",_this];
for "_y" from 0 to (count _this)-1 step 50 do { //Only 50 per call to not exceed max message length
    private _towersToProcess = (_this select [_y,50]);
    private _towerData = _towersToProcess apply {
        private _range = [GVAR(radioTowerList),_x] call CBA_fnc_hashGet;
        private _netID = netID _x;
        ([_netID,_range,position _x] joinString ";")
    };
    diag_log _towerData;
    systemChat "sendBatch";
    "task_force_radio_pipe" callExtension format["RadioTwrAdd	%1~", _towerData joinString TF_new_line];
};
