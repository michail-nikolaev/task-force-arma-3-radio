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
private ["_logic", "_activated", "_units"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_units = [_this,1,[],[[]]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then
{
	private ["_west", "_westLR", "_east", "_eastLR", "_guer", "_guerLR"];
	_west = call TFAR_fnc_generateSwSettings;
	_west set [2,STR (_logic getVariable "WestFreq")];
	_east = call TFAR_fnc_generateSwSettings;
	_east set [2,STR (_logic getVariable "EastFreq")];
	_guer = call TFAR_fnc_generateSwSettings;
	_guer set [2,STR (_logic getVariable "GuerFreq")];

	_westLR = call TFAR_fnc_generateLrSettings;
	_westLR set [2,STR (_logic getVariable "WestLrFreq")];
	_eastLR = call TFAR_fnc_generateLrSettings;
	_eastLR set [2,STR (_logic getVariable "EastLrFreq")];
	_guerLR = call TFAR_fnc_generateLrSettings;
	_guerLR set [2,STR (_logic getVariable "GuerLrFreq")];

	if (count _units == 0) then
	{
		TF_use_saved_sw_setting = false;
		tf_same_sw_frequencies_for_side = true;
		tf_freq_west = _west;
		tf_freq_east = _east;
		tf_freq_guer = _guer;

		TF_use_saved_lr_setting = false;
		tf_same_lr_frequencies_for_side = true;
		tf_freq_west_lr = _westLR;
		TF_freq_east_lr = _eastLR;
		tf_freq_guer_lr = _guerLR;
	}
	else
	{
		if (isServer) then
		{
			tf_same_lr_frequencies_for_side = true;
			{
				private "_side";
				_side = _x call BIS_fnc_objectSide;

				switch (_side) do {
					case west: {
						(group _x) setVariable ["tf_sw_frequency", _west, true];
						(group _x) setVariable ["tf_lr_frequency", _westLR, true];
					};
					case east: {
						(group _x) setVariable ["tf_sw_frequency", _east, true];
						(group _x) setVariable ["tf_lr_frequency", _eastLR, true];
					};
					case resistance: {
						(group _x) setVariable ["tf_sw_frequency", _guer, true];
						(group _x) setVariable ["tf_lr_frequency", _guerLR, true];
					};
				};
			} count _units;
		};
	};
};

true