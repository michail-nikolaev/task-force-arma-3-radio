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
		private "_copyIndex";
		_copyIndex = 0;
		{
			player addItem _x;
			if (count TF_settingsToCopy > _copyIndex) then {
				if ([_x, TF_settingsToCopy select _copyIndex] call TFAR_fnc_isSameRadio) then {
					[_x,TF_settingsToCopy select _copyIndex] call TFAR_fnc_CopySettings;
					_copyIndex = _copyIndex + 1;
				};
			};
			[_x,player] call TFAR_fnc_setRadioOwner;
		} count _response;
		TF_settingsToCopy = [];
		if ((count _response > 0) and (TF_first_radio_request)) then {
			TF_first_radio_request = false;
			player assignItem (_response select 0);
		};
		titleText ["", "PLAIN"];
	};
	TF_last_request_time = time;
};
TF_radio_request_mutex = false;