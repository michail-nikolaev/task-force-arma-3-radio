#include "script_component.hpp"

if (!isMultiplayer && !is3DENMultiplayer) exitWith {}; //Don't do anything in Singleplayer

if (isServer or isDedicated) then {
    [] spawn TFAR_fnc_serverInit;
};

if (hasInterface) then {
    [] spawn TFAR_fnc_clientInit;
};
