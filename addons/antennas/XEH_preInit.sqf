#include "script_component.hpp"

#include "XEH_PREP.sqf"

if (!hasInterface) exitWith {}; //Don't need on Headless and dedicated Servers

GVAR(radioTowerList) = [] call CBA_fnc_hashCreate;

["TFAR_ConfigRefresh",{
    #ifdef DEBUG_MODE_FULL
        systemChat "TFAR_ConfigRefresh";
    #endif
    ([(GVAR(radioTowerList))] call CBA_fnc_hashKeys) call FUNC(pluginAddRadioTower);
}] call CBA_fnc_addEventHandler;
