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
	if (count _units == 0) exitWith { hint "TFAR - No units set for Frequency Module";diag_log "TFAR - No units set for Frequency Module";};
	if (isServer) then
	{
		private ["_swFreq", "_lrFreq", "_freqTest"];
		_swFreq = call TFAR_fnc_generateSwSettings;
		(_swFreq select 2) set [0,STR (_logic getVariable "PrFreq")];
		_lrFreq = call TFAR_fnc_generateLrSettings;
		(_lrFreq select 2) set [0,STR (_logic getVariable "LrFreq")];
		{
			_freqTest = (group _x) getVariable "tf_sw_frequency";
			if (!isNil "_freqTest") then {hint format["TFAR - tf_sw_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];diag_log format["TFAR - tf_sw_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];};
			
			_freqTest = (group _x) getVariable "tf_lr_frequency";
			if (!isNil "_freqTest") then {hint format["TFAR - tf_lr_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];diag_log format["TFAR - tf_lr_frequency already set, might be assigning a group (%1) to multiple frequency modules.", (group _x)];};
			
			(group _x) setVariable ["tf_sw_frequency", _swFreq, true];
			(group _x) setVariable ["tf_lr_frequency", _lrFreq, true];
		} count _units;
	};
};

true
