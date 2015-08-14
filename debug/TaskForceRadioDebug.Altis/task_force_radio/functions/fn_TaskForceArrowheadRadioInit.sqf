/*
 	Name: TFAR_fnc_TaskForceArrowheadRadioInit
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
		Initialises TFAR, server and client.
 	
 	Parameters: 
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		Called by ArmA via functions library.
*/
<<<<<<< HEAD
TF_ADDON_VERSION = "0.9.7.3";

#include "common.sqf"

if (isServer or isDedicated) then {
	[] spawn TFAR_fnc_ServerInit;
};
if (hasInterface) then {
	[] spawn TFAR_fnc_ClientInit;
};
=======
TF_ADDON_VERSION = "0.9.2";

#include "common.sqf"

if (isServer or isDedicated) then
{
	[] spawn TFAR_fnc_ServerInit;
};
if (hasInterface) then
{
	[] spawn TFAR_fnc_ClientInit;
};
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
