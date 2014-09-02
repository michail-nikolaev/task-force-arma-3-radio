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
TF_ADDON_VERSION = "0.9.2";

#include "common.sqf"

if (isServer or isDedicated) then {
	[] spawn TFAR_fnc_ServerInit;
};
if (hasInterface) then {
	[] spawn TFAR_fnc_ClientInit;
};