#include "script_component.hpp"

PREP(deleteRadioTower);
PREP(initRadioTower);
PREP(pluginAddRadioTower);
PREP(pluginRemoveRadioTower);

if (!hasInterface) exitWith {}; //Don't need on Headless and dedicated Servers

GVAR(radioTowerList) = [] call CBA_fnc_hashCreate;

["TFAR_ConfigRefresh",{
    //systemChat "TFAR_ConfigRefresh";
    ((GVAR(radioTowerList)) call CBA_fnc_hashKeys) call DFUNC(pluginAddRadioTower);
}] call CBA_fnc_addEventHandler;
