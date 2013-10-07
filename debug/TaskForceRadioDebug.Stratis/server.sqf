#define MAX_ANPRC_COUNT 1000

[] spawn {
	waitUntil {time > 0};
	anprc152_count = 1;
	while {true} do {
		{
			if (isPlayer _x) then 
			{
				_variableName = "radio_request_" + (getPlayerUID _x) + str (side _x);
				_radio_request = missionNamespace getVariable (_variableName);
				if !(isNil "_radio_request") then
				{
					missionNamespace setVariable [_variableName, nil];
					hint str(_radio_request);
					(owner (_x)) publicVariableClient (_variableName);
					_responseVariableName = "radio_response_" + (getPlayerUID _x) + str (side _x);
					_response = [];
					_response resize _radio_request;
					for "_next_radio" from 1 to _radio_request do
					{
						_new_radio_id = format["anprc152_%1", anprc152_count];					
						_response set [(_next_radio - 1), _new_radio_id];
	
						anprc152_count = anprc152_count + 1;
						if (anprc152_count > MAX_ANPRC_COUNT) then 
						{
							anprc152_count = 1;
						};
	
					};
					missionNamespace setVariable [_responseVariableName, _response];
					(owner (_x)) publicVariableClient (_responseVariableName);
				};
			};
		} forEach allUnits;
		sleep 1;
	};

};