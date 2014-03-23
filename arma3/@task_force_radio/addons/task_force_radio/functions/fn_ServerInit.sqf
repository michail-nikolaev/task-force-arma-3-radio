/*
 	Name: TFAR_fnc_serverInit
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Initialises the server and the server loop.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_serverInit;
*/
#define MAX_RADIO_COUNT 1000

if (isNil "tf_same_sw_frequencies_for_side") then {
	tf_same_sw_frequencies_for_side = false;
};
if (isNil "tf_same_lr_frequencies_for_side") then {
	tf_same_lr_frequencies_for_side = true;
};

[] spawn {
	private ["_variableName", "_radio_request", "_responseVariableName", "_response", "_task_force_radio_used", "_last_check", "_group_freq", "_allUnits"];

	if (isNil "tf_freq_west") then {
		tf_freq_west = call TFAR_fnc_generateSwSettings;
	};
	if (isNil "ft_freq_east") then {
		if (isNil "tf_freq_east") then {
			TF_freq_east = call TFAR_fnc_generateSwSettings;
		};
	}
	else
	{
		TF_freq_east =	ft_freq_east;
	};
	if (isNil "tf_freq_guer") then {
		tf_freq_guer = call TFAR_fnc_generateSwSettings;
	};

	if (isNil "tf_freq_west_lr") then {
		tf_freq_west_lr = call TFAR_fnc_generateLrSettings;
	};
	if (isNil "ft_freq_east_lr") then {
		if (isNil "tf_freq_east_lr") then {
			TF_freq_east_lr = call TFAR_fnc_generateLrSettings;
		};
	}
	else
	{
		TF_freq_east_lr =	ft_freq_east_lr;
	};
	if (isNil "tf_freq_guer") then {
		tf_freq_guer = call TFAR_fnc_generateSwSettings;
	};
	if (isNil "tf_freq_guer_lr") then {
		tf_freq_guer_lr = call TFAR_fnc_generateLrSettings;
	};

	waitUntil {time > 0};
	TF_server_addon_version = TF_ADDON_VERSION;
	publicVariable "TF_server_addon_version";

	TF_Radio_Count = [];

	while {true} do {
		{
			_group_freq = _x getVariable "tf_sw_frequency";
			if (isNil "_group_freq") then {
				if !(tf_same_sw_frequencies_for_side) then {
					_x setVariable ["tf_sw_frequency", call TFAR_fnc_generateSwSettings, true];
				} else {
					switch (side _x) do {
						case west: {
							_x setVariable ["tf_sw_frequency", tf_freq_west, true];
						};
						case east: {
							_x setVariable ["tf_sw_frequency", tf_freq_east, true];
						};
						default {
							_x setVariable ["tf_sw_frequency", tf_freq_guer, true];
						};
					};
				};
			};
			_group_freq = _x getVariable "tf_lr_frequency";
			if (isNil "_group_freq") then {
				if !(tf_same_lr_frequencies_for_side) then {
					_x setVariable ["tf_lr_frequency", call TFAR_fnc_generateLrSettings, true];
				} else {
					switch (side _x) do {
						case west: {
							_x setVariable ["tf_lr_frequency", tf_freq_west_lr, true];
						};
						case east: {
							_x setVariable ["tf_lr_frequency", tf_freq_east_lr, true];
						};
						default {
							_x setVariable ["tf_lr_frequency", tf_freq_guer_lr, true];
						};
					};
				};
			};
		} forEach allGroups;

		_allUnits = (if(isMultiplayer)then{playableUnits}else{switchableUnits});
		{
			if (isPlayer _x) then
			{
				_variableName = "radio_request_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
				_radio_request = missionNamespace getVariable (_variableName);
				if !(isNil "_radio_request") then
				{
					missionNamespace setVariable [_variableName, nil];
					(owner (_x)) publicVariableClient (_variableName);
					_responseVariableName = "radio_response_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
					_response = [];
					{
						private ["_radio", "_count"];
						_radio = _x;
						if !(_radio call TFAR_fnc_isPrototypeRadio) then
						{
							_radio = inheritsFrom (configFile >> "CfgWeapons" >> _radio);
						};
						_count = -1;
						{
							if ((_x select 0) == _radio) exitWith
							{
								_x set [1, (_x select 1) + 1];
								if ((_x select 1) > MAX_RADIO_COUNT) then
								{
									_x set [1, 1];
								};
								_count = (_x select 1);
							};
						} count TF_Radio_Count;
						if (_count == -1) then
						{
							TF_Radio_Count set [(count TF_Radio_Count), [_x,1]];
							_count = 1;
						};
						_response set [(count _response), format["%1_%2", _radio, _count]];
					} count _radio_request;
					missionNamespace setVariable [_responseVariableName, _response];
					(owner (_x)) publicVariableClient (_responseVariableName);
				};
				_task_force_radio_used = _x getVariable "tf_force_radio_active";
				_variableName = "no_radio_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
				if (isNil "_task_force_radio_used") then {
					_last_check = missionNamespace getVariable _variableName;

					if (isNil "_last_check") then {
						missionNamespace setVariable [_variableName, time];
					} else {
						if (time - _last_check > 30) then {
							[["LOOKS LIKE TASK FORCE RADIO ADDON NOT ENABLED OR VERSION LESS THAN 0.8.1"],"BIS_fnc_guiMessage",(owner _x), false] spawn BIS_fnc_MP;
							_x setVariable ["tf_force_radio_active", "error_shown", true];
						};
					};
				} else {
					missionNamespace setVariable [_variableName, nil];
				};
			};
		} count _allUnits;
		sleep 1;
	};
};
