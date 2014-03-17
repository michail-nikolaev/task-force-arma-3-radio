/*
 	Name: TFAR_fnc_initialiseBaseModule
 	
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
_units = [_this,1,[],[[]]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then {
	private ["_LRradio","_radio", "_currentSide", "_swFreq", "_lrFreq"];
	
	_swFreq = call TFAR_fnc_generateSwSettings;
	(_swFreq select 2) set [0,STR (_logic getVariable "PrFreq")];
	_lrFreq = call TFAR_fnc_generateLrSettings;
	(_lrFreq select 2) set [0,STR (_logic getVariable "LrFreq")];
	
	_LRradio = _logic getVariable "LRradio";
	_radio = _logic getVariable "Radio";
	_currentSide = "North";
	
	{
		if ((str _currentSide) != (str side _x)) then {
			_currentSide = side _x;

			switch (_currentSide) do {
				case west: {
					tf_west_radio_code = _logic getVariable "Encryption";
					if (([_LRradio, "tf_hasLrRadio",0] call TFAR_fnc_getConfigProperty) == 1) then {
						TF_defaultWestBackpack = _LRradio;
					} else {
						diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
						hint format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
					};
					if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") == 1) then {
						TF_defaultWestPersonalRadio = _radio;
					} else {
						diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
						hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
					};
					if (isServer) then
					{
						if (!isNil "tf_freq_west") then {hint "TFAR - tf_freq_west already set, module overriding.";diag_log "TFAR - tf_freq_west already set, module overriding.";};
						if (!isNil "tf_freq_west_lr") then {hint "TFAR - tf_freq_west_lr already set, module overriding.";diag_log "TFAR - tf_freq_west_lr already set, module overriding.";};
						tf_freq_west = _swFreq;
						tf_freq_west_lr = _lrFreq;
					};
				};
				case east: {
					tf_east_radio_code = _logic getVariable "Encryption";
					if (([_LRradio, "tf_hasLrRadio",0] call TFAR_fnc_getConfigProperty) == 1) then {
						TF_defaultEastBackpack = _LRradio;
					} else {
						diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
						hint format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
					};
					if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") == 1) then {
						TF_defaultEastPersonalRadio = _radio;
					} else {
						diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
						hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
					};
					if (isServer) then
					{
						if (!isNil "tf_freq_east") then {hint "TFAR - tf_freq_east already set, module overriding.";diag_log "TFAR - tf_freq_east already set, module overriding.";};
						if (!isNil "tf_freq_east_lr") then {hint "TFAR - tf_freq_east_lr already set, module overriding.";diag_log "TFAR - tf_freq_east_lr already set, module overriding.";};
						tf_freq_east = _swFreq;
						tf_freq_east_lr = _lrFreq;
					};
				};
				default	{
					tf_guer_radio_code = _logic getVariable "Encryption";
					if (([_LRradio, "tf_hasLrRadio",0] call TFAR_fnc_getConfigProperty) == 1) then {
						TF_defaultGuerBackpack = _LRradio;
					} else {
						diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
						hint format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
					};
					if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") == 1) then {
						TF_defaultGuerPersonalRadio = _radio;
					} else {
						diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
						hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
					};
					if (isServer) then
					{
						if (!isNil "tf_freq_guer") then {hint "TFAR - tf_freq_guer already set, module overriding.";diag_log "TFAR - tf_freq_guer already set, module overriding.";};
						if (!isNil "tf_freq_guer_lr") then {hint "TFAR - tf_freq_guer_lr already set, module overriding.";diag_log "TFAR - tf_freq_guer_lr already set, module overriding.";};
						tf_freq_guer = _swFreq;
						tf_freq_guer_lr = _lrFreq;
					};
				};
			};
		};
	} count _units;
};

true