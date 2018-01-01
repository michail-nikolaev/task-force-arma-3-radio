#include "script_component.hpp"

/*
 * Name: TFAR_antennas_fnc_deleteRadioTower
 *
 * Author: Dedmen
 * De-initializes a Radio Tower
 *
 * Arguments:
 * 0: the tower <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * _this call TFAR_antennas_fnc_deleteRadioTower;
 *
 * Public: yes
 */

[GVAR(radioTowerList), _tower] call CBA_fnc_hashRem;

[_tower] call FUNC(pluginRemoveRadioTower);
