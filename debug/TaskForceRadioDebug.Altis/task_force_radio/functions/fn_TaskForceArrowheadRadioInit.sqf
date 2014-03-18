TF_ADDON_VERSION = "0.9.0";

#include "common.sqf"

if (isServer or isDedicated) then
{
	[] spawn TFAR_fnc_ServerInit;
};
if (hasInterface) then
{
	[] spawn TFAR_fnc_ClientInit;
};