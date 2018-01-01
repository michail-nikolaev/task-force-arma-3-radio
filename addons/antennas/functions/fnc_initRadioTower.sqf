#include "script_component.hpp"

/*
 * Name: TFAR_antennas_fnc_initRadioTower
 *
 * Author: Dedmen
 * Initializes a Radio Tower
 *
 * Arguments:
 * 0: the tower <OBJECT>
 * 1: the Transmitting Range of the Tower <SCALAR>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this, 50000] call TFAR_antennas_fnc_initRadioTower;
 *
 * Public: yes
 */
params ["_tower","_range"];

TRACE_1("TFAR_antennas_fnc_initRadioTower",_this);

[GVAR(radioTowerList), _tower, _range] call CBA_fnc_hashSet;

[FUNC(pluginAddRadioTower),[_tower]] call CBA_fnc_execNextFrame; //netID may still be 0:0 directly at Init EH
