private ["_radio_count", "_variableName", "_responseVariableName", "_response"];

waitUntil {
	if (!TF_radio_request_mutex) exitWith {TF_radio_request_mutex = true; true};
	false;
};
if (time - TF_last_request_time > 3) then {
	TF_last_request_time = time;
	_variableName = "radio_request_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
	_radio_count = _this call TFAR_fnc_radioToRequestCount;

	if (_radio_count > 0) then {
		missionNamespace setVariable [_variableName, _radio_count];
		_responseVariableName = "radio_response_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
		 missionNamespace setVariable [_responseVariableName, nil];
		publicVariableServer _variableName;
		titleText [localize ("STR_wait_radio"), "PLAIN"];
		waitUntil {!(isNil _responseVariableName)};
		_response = missionNamespace getVariable _responseVariableName;	
		{
			player addItem _x;
		} forEach _response;
		if ((count _response > 0) and (TF_first_radio_request)) then 
		{
			TF_first_radio_request = false;
			player assignItem (_response select 0);
		};
		titleText ["", "PLAIN"];
	};
	TF_last_request_time = time;
};
TF_radio_request_mutex = false;