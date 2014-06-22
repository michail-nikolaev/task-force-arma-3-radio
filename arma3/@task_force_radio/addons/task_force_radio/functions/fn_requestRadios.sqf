/*
 	Name: TFAR_fnc_requestRadios
 	
 	Author(s):
		NKey

 	Description:
		Checks whether the player needs to have radios converted to "instanced" versions,
		handles waiting for response from server with radio classnames and applying them to the player.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		spawn TFAR_fnc_requestRadios;
*/
private ["_radiosToRequest", "_variableName", "_responseVariableName", "_response"];

waitUntil {
	if (!TF_radio_request_mutex) exitWith {TF_radio_request_mutex = true; true};
	false;
};
if (time - TF_last_request_time > 3) then {
	TF_last_request_time = time;
	_variableName = "radio_request_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
	_radiosToRequest = _this call TFAR_fnc_radioToRequestCount;

	if ((count _radiosToRequest) > 0) then {
		missionNamespace setVariable [_variableName, _radiosToRequest];
		_responseVariableName = "radio_response_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
		missionNamespace setVariable [_responseVariableName, nil];
		publicVariableServer _variableName;
		titleText [localize ("STR_wait_radio"), "PLAIN"];
		waitUntil {!(isNil _responseVariableName)};
		_response = missionNamespace getVariable _responseVariableName;
		if ((typename _response) == "ARRAY") then {
			private "_radioCount";
			_radioCount = count _response;
			if (_radioCount > 0) then {
				if (TF_first_radio_request) then {
					TF_first_radio_request = false;
					player linkItem (_response select 0);
				};
				_radioCount = _radioCount - 1;
				for "_index" from 1 to _radioCount do {
					player addItem (_response select _index);
				};
			};
		}else{
			hintC _response;
		};
		titleText ["", "PLAIN"];
	};
	TF_last_request_time = time;
};
TF_radio_request_mutex = false;