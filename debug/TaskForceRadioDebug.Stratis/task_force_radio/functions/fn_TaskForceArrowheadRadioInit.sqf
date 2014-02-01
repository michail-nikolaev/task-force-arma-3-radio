TF_ADDON_VERSION = "0.8.3";

#include "common.sqf"

if (isServer or isDedicated) then
{
	[] spawn TFAR_fnc_ServerInit;
};
if (hasInterface) then
{
	[] spawn TFAR_fnc_ClientInit;
};