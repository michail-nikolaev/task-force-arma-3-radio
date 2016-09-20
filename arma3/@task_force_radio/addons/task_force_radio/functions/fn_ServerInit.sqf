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
private ["_variableName", "_radio_request", "_responseVariableName", "_response", "_task_force_radio_used", "_last_check", "_allUnits"];

// cba settings
#include "cba_settings.sqf"

TF_server_addon_version = TF_ADDON_VERSION;
publicVariable "TF_server_addon_version";

waitUntil {sleep 0.1;time > 0};

TF_Radio_Count = [];

while {true} do {		
	call TFAR_fnc_processGroupFrequencySettings;
	_allUnits = allUnits;	
	{
		_allUnits pushBack _x;
		true;
	} count (call BIS_fnc_listCuratorPlayers);
	
	{
		if (isPlayer _x) then {
			_variableName = "radio_request_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
			_radio_request = missionNamespace getVariable (_variableName);
			if !(isNil "_radio_request") then {
				missionNamespace setVariable [_variableName, nil];
				(owner (_x)) publicVariableClient (_variableName);
				_responseVariableName = "radio_response_" + (getPlayerUID _x) + str (_x call BIS_fnc_objectSide);
				_response = [];
				if (typename _radio_request == "ARRAY") then {
					{
						private ["_radio", "_count"];
						_radio = _x;
						if !(_radio call TFAR_fnc_isPrototypeRadio) then {
							_radio = configname inheritsFrom (configFile >> "CfgWeapons" >> _radio);
						};
						_count = -1;
						{
							if ((_x select 0) == _radio) exitWith {
								_x set [1, (_x select 1) + 1];
								if ((_x select 1) > MAX_RADIO_COUNT) then {
									_x set [1, 1];
								};
								_count = (_x select 1);
							};
						} count TF_Radio_Count;
						if (_count == -1) then {
							TF_Radio_Count pushBack [_x,1];
							_count = 1;
						};
						_response pushBack format["%1_%2", _radio, _count];
						true;
					} count _radio_request;
				} else {
					_response = "ERROR:47";
					diag_log format ["TFAR - ERROR:47 - Request Content: %1; Requested By: %2", _radio_reqest, _x];
				};
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
