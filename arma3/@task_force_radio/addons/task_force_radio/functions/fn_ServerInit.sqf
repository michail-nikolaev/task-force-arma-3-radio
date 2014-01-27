#define MAX_ANPRC152_COUNT 1000
#define MAX_ANPRC148JEM_COUNT 1000
#define MAX_FADAK_COUNT 1000

if (isNil "tf_same_sw_frequencies_for_side") then {
	tf_same_sw_frequencies_for_side = false;
};
if (isNil "tf_same_lr_frequencies_for_side") then {
	tf_same_lr_frequencies_for_side = true;
};

[] spawn {
	private ["_variableName", "_radio_request", "_responseVariableName", "_response", "_new_radio_id", "_task_force_radio_used", "_last_check", "_group_freq"];
	
	if (isNil "tf_freq_west") then {
		tf_freq_west = call TFAR_fnc_generateSwSettings;
	};
	if (isNil "ft_freq_east") then {
		ft_freq_east = call TFAR_fnc_generateSwSettings;
	};
	if (isNil "tf_freq_guer") then {
		tf_freq_guer = call TFAR_fnc_generateSwSettings;
	};

	if (isNil "tf_freq_west_lr") then {
		tf_freq_west_lr = call TFAR_fnc_generateLrSettings;
	};
	if (isNil "ft_freq_east_lr") then {
		ft_freq_east_lr = call TFAR_fnc_generateLrSettings;
	};
	if (isNil "tf_freq_guer_lr") then {
		tf_freq_guer_lr = call TFAR_fnc_generateLrSettings;
	};

	
	waitUntil {time > 0};
	server_addon_version = TF_ADDON_VERSION;
	publicVariable "server_addon_version";

	anprc152_count = 1;
	anprc148jem_count = 1;
	fadak_count = 1;

	while {true} do {
		{		
			_group_freq = _x getVariable "tf_sw_frequency";
			if (isNil "_group_freq") then {
				if !(tf_same_sw_frequencies_for_side) then {
					_x setVariable ["tf_sw_frequency", call TFAR_fnc_generateSwSettings, true];
				} else {		
					if (side _x == west) then {
						_x setVariable ["tf_sw_frequency", tf_freq_west, true];
					} else {
						if (side _x == east) then {
							_x setVariable ["tf_sw_frequency", ft_freq_east, true];
						} else {
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
					if (side _x == west) then {
						_x setVariable ["tf_lr_frequency", tf_freq_west_lr, true];
					} else {
						if (side _x == east) then {
							_x setVariable ["tf_lr_frequency", ft_freq_east_lr, true];
						} else {
							_x setVariable ["tf_lr_frequency", tf_freq_guer_lr, true];
						};
					};
				};
			};		
		} forEach allGroups;

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
					_response resize _radio_request;
					for "_next_radio" from 1 to _radio_request do
					{
						if ((_x call BIS_fnc_objectSide) == west) then {
							_new_radio_id = format["tf_anprc152_%1", anprc152_count];					
							_response set [(_next_radio - 1), _new_radio_id];
		
							anprc152_count = anprc152_count + 1;
							if (anprc152_count > MAX_ANPRC152_COUNT) then 
							{
								anprc152_count = 1;
							};
						} else {
							if ((_x call BIS_fnc_objectSide) == east) then {
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
		} forEach allUnits;		
		sleep 1;
	};
};