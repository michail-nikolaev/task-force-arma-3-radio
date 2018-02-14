#include "script_component.hpp"

/*
  Name: TFAR_antennas_fnc_pluginRemoveRadioTower

  Author: Dedmen
    Tells Teamspeak that a Tower disappeared
    Performancewise it's best to collect towers and pass multiple in one call.

  Arguments:
    0: the Tower <OBJECT>

  Return Value:
    None

  Example:
    [_tower1, _tower2] call TFAR_antennas_fnc_pluginRemoveRadioTower;

  Public: yes
 */

for "_y" from 0 to (count _this)-1 step 50 do { //Only 50 per call to not exceed max message length
    private _towersToProcess = (_this select [_y,50]);
    private _towerData = _towersToProcess apply {netID _x};

    "task_force_radio_pipe" callExtension format["RadioTwrDel	%1~", _towerData joinString TF_new_line];
};
