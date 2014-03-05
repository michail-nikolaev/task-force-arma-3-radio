/*
 	Name: TFAR_fnc_initialiseEnforceUsageModule
 	
 	Author(s):
		L-H
 	
 	Description:
		Initialises variables based on module settings.
 	
 	Parameters:
 	
 	Returns:
		Nothing
 	
 	Example:
	
 */
private ["_logic", "_activated"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then
{
	tf_no_auto_long_range_radio = !(_logic getVariable "TeamLeaderRadio");
};

true