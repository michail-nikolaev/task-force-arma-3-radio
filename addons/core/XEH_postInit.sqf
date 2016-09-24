#include "script_component.hpp"


if (isServer or isDedicated) then {
	[] spawn TFAR_fnc_ServerInit;
};

if (hasInterface) then {
	[] spawn TFAR_fnc_ClientInit;
};
