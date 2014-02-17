/*
 	Name: TFAR_fnc_initialiseFreqModule
 	
 	Author(s):
		L-H
 	
 	Description:
		Initialises variables based on module settings.
 	
 	Parameters:
 	
 	Returns:
		Nothing
 	
 	Example:
	
 */
#include "common.sqf"
private ["_logic", "_activated"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then
{
	TF_use_saved_sw_setting = false;
	tf_same_sw_frequencies_for_side = true;
	tf_freq_west = call TFAR_fnc_generateSwSettings;
	tf_freq_west set [2,STR (_logic getVariable "WestFreq")];
	tf_freq_east = call TFAR_fnc_generateSwSettings;
	tf_freq_east set [2,STR (_logic getVariable "EastFreq")];
	tf_freq_guer = call TFAR_fnc_generateSwSettings;
	tf_freq_guer set [2,STR (_logic getVariable "GuerFreq")];
	
	TF_use_saved_lr_setting = false;
	tf_same_lr_frequencies_for_side = true;
	tf_freq_west_lr = call TFAR_fnc_generateLrSettings;
	tf_freq_west_lr set [2,STR (_logic getVariable "WestLrFreq")];
	TF_freq_east_lr = call TFAR_fnc_generateLrSettings;
	TF_freq_east_lr set [2,STR (_logic getVariable "EastLrFreq")];
	tf_freq_guer_lr = call TFAR_fnc_generateLrSettings;
	tf_freq_guer_lr set [2,STR (_logic getVariable "GuerLrFreq")];
};

true