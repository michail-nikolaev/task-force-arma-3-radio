#include "script_component.hpp"

if (!isMultiplayer && !is3DENMultiplayer) exitWith {}; //Don't do anything in Singleplayer


if (hasInterface) then {
    call TFAR_fnc_addDiaryRecord;

    [   {time > 0 && !(isNull player)},
        TFAR_fnc_clientInit
    ] call CBA_fnc_waitUntilAndExecute;
};
