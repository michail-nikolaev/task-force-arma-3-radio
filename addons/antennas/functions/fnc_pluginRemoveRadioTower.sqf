#include "script_component.hpp"

/*
    Name: TFAR_fnc_pluginRemoveRadioTower

    Author(s):
        Dedmen

    Description:
        Tells Teamspeak that a Tower disappeared
        Performancewise it's best to collect towers and pass multiple in one call.

    Parameters:
        ARRAY:
            OBJECT: the Tower

    Returns:
        NOTHING

    Example:
        [_tower1,_tower2] call TFAR_fnc_pluginAddRadioTower;
*/

for "_y" from 0 to (count _this)-1 step 50 do { //Only 50 per call to not exceed max message length
    private _towersToProcess = (_this select [_y,50]);
    private _towerData = _towersToProcess apply {netID _x};
    "task_force_radio_pipe" callExtension (["RadioTwrDel",(_towerData joinString TF_new_line)] joinString "	");
};
