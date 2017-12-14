#include "script_component.hpp"

if (!isMultiplayer && !is3DENMultiplayer) exitWith {}; //Don't do anything in Singleplayer

if (hasInterface) then {
    [   {time > 0 && !(isNull player)},
        TFAR_fnc_clientInit
    ] call CBA_fnc_waitUntilAndExecute;
};
