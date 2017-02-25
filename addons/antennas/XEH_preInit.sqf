#include "script_component.hpp"

PREP(deleteRadioTower);
PREP(initRadioTower);
PREP(pluginAddRadioTower);
PREP(pluginRemoveRadioTower);

if (!hasInterface) exitWith {}; //Don't need on Headless and dedicated Servers

GVAR(radioTowerList) = [] call CBA_fnc_hashCreate;


["TFAR_ConfigRefresh",{
    systemChat "TFAR_ConfigRefresh";
    GVAR(radioTowerList) params ["", "_keys"]; //#TODO convert to https://github.com/CBATeam/CBA_A3/pull/590
    _keys call DFUNC(pluginAddRadioTower);
}] call CBA_fnc_addEventHandler
