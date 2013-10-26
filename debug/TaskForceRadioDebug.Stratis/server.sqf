#define MAX_ANPRC152_COUNT 1000
#define MAX_ANPRC148JEM_COUNT 1000
#define MAX_FADAK_COUNT 1000

[] spawn {
	private ["_variableName", "_radio_request", "_responseVariableName", "_response", "_new_radio_id", "_task_force_radio_used", "_last_check"];
	waitUntil {time > 0};
	server_addon_version = ADDON_VERSION;
	publicVariable "server_addon_version";

	anprc152_count = 1;
	anprc148jem_count = 1;
	fadak_count = 1;

	while {true} do {
		{
			if (isPlayer _x) then 
			{
				_variableName = "radio_request_" + (getPlayerUID _x) + str (side _x);
				_radio_request = missionNamespace getVariable (_variableName);
				if !(isNil "_radio_request") then
				{
					missionNamespace setVariable [_variableName, nil];
					(owner (_x)) publicVariableClient (_variableName);
					_responseVariableName = "radio_response_" + (getPlayerUID _x) + str (side _x);
					_response = [];
					_response resize _radio_request;
					for "_next_radio" from 1 to _radio_request do
					{
						if (side player == west) then {
							_new_radio_id = format["tf_anprc152_%1", anprc152_count];					
							_response set [(_next_radio - 1), _new_radio_id];
		
							anprc152_count = anprc152_count + 1;
							if (anprc152_count > MAX_ANPRC152_COUNT) then 
							{
								anprc152_count = 1;
							};
						} else {
							if (side player == east) then {
								_new_radio_id = format["tf_fadak_%1", fadak_count];					
								_response set [(_next_radio - 1), _new_radio_id];
			
								fadak_count = fadak_count + 1;
								if (fadak_count > MAX_FADAK_COUNT) then 
								{
									fadak_count = 1;
								};
							} else {	
								_new_radio_id = format["tf_anprc148jem_%1", anprc148jem_count];					
								_response set [(_next_radio - 1), _new_radio_id];
			
								anprc148jem_count = anprc148jem_count + 1;
								if (anprc148jem_count > MAX_ANPRC148JEM_COUNT) then 
								{
									anprc148jem_count = 1;
								};
							};
						};
	
					};
					missionNamespace setVariable [_responseVariableName, _response];
					(owner (_x)) publicVariableClient (_responseVariableName);
				};
				_task_force_radio_used = _x getVariable "tf_force_radio_active";
				if (isNil "_task_force_radio_used") then {

					_variableName = "no_radio_" + (getPlayerUID _x) + str (side _x);
					_last_check = missionNamespace getVariable _variableName;

					if (isNil "_last_check") then {
						missionNamespace setVariable [_variableName, time];
					} else {
						if (time - _last_check > 30) then {
							[["TASK FORCE RADIO ADDON NOT ENABLED OR VERSION LESS THAN 0.8.0"],"BIS_fnc_guiMessage",(owner _x), false] spawn BIS_fnc_MP;
							_x setVariable ["tf_force_radio_active", "error_shown", true];
						};
					};					

				};
			};
		} forEach allUnits;
		sleep 1;
	};

};