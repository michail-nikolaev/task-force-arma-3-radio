/*
 	Name: TFAR_fnc_requestRadios
 	
 	Author(s):
		NKey
<<<<<<< HEAD
		L-H
=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086

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
<<<<<<< HEAD
private ["_radiosToRequest", "_variableName", "_responseVariableName", "_response", "_fnc_CopySettings"];

_fnc_CopySettings = {
	private ["_source", "_destination", "_variableName", "_localSettings"];
	if ((_this select 0) > (_this select 1)) then {
		if ([(_this select 2), TF_settingsToCopy select (_this select 1)] call TFAR_fnc_isSameRadio) then {			
			_source = TF_settingsToCopy select (_this select 1);
			_variableName = format["%1_settings_local", _source];
			_localSettings = missionNamespace getVariable _variableName;			
			if !(isNil "_variableName") then {
				_destination = (_this select 2);
				[_destination, _localSettings, true] call TFAR_fnc_setSwSettings;
			};
			_copyIndex = _copyIndex + 1;
		};
	};	
	((_this select 1) + 1)
};
=======
private ["_radiosToRequest", "_variableName", "_responseVariableName", "_response"];
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086

waitUntil {
	if (!TF_radio_request_mutex) exitWith {TF_radio_request_mutex = true; true};
	false;
};
<<<<<<< HEAD

if ((time - TF_last_request_time > 3) or {_this}) then {
=======
if (time - TF_last_request_time > 3) then {
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	TF_last_request_time = time;
	_variableName = "radio_request_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
	_radiosToRequest = _this call TFAR_fnc_radioToRequestCount;

	if ((count _radiosToRequest) > 0) then {
		missionNamespace setVariable [_variableName, _radiosToRequest];
		_responseVariableName = "radio_response_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
		missionNamespace setVariable [_responseVariableName, nil];
<<<<<<< HEAD
		publicVariableServer _variableName;		
		[parseText(localize ("STR_wait_radio")), 10] call TFAR_fnc_ShowHint;

		waitUntil {!(isNil _responseVariableName)};
		_response = missionNamespace getVariable _responseVariableName;
		private "_copyIndex";
		_copyIndex = 0;
		if ((typename _response) == "ARRAY") then {
			private ["_radioCount","_settingsCount", "_startIndex"];
			_radioCount = count _response;
			_settingsCount = count TF_SettingsToCopy;
			_startIndex = 0;
			if (_radioCount > 0) then {
				if (TF_first_radio_request) then {
					TF_first_radio_request = false;
					TFAR_currentUnit linkItem (_response select 0);
					_copyIndex = [_settingsCount, _copyIndex, (_response select 0)] call _fnc_CopySettings;					
					[(_response select 0), getPlayerUID player, true] call TFAR_fnc_setRadioOwner;
					_startIndex = 1;
				};
				_radioCount = _radioCount - 1;
				for "_index" from _startIndex to _radioCount do {
					TFAR_currentUnit addItem (_response select _index);
					_copyIndex = [_settingsCount, _copyIndex, (_response select _index)] call _fnc_CopySettings;
					[(_response select _index), getPlayerUID player, true] call TFAR_fnc_setRadioOwner;
				};
				//TF_settingsToCopy = [];
=======
		publicVariableServer _variableName;
		titleText [localize ("STR_wait_radio"), "PLAIN"];
		waitUntil {!(isNil _responseVariableName)};
		_response = missionNamespace getVariable _responseVariableName;
		if (typename _response == "ARRAY") then {
			{
				player addItem _x;
			} count _response;
			if ((count _response > 0) and (TF_first_radio_request)) then 
			{
				TF_first_radio_request = false;
				player assignItem (_response select 0);
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
			};
		}else{
			hintC _response;
		};
<<<<<<< HEAD
		call TFAR_fnc_HideHint;
		//								unit, radios
		["OnRadiosReceived", TFAR_currentUnit, [TFAR_currentUnit, _response]] call TFAR_fnc_fireEventHandlers;
=======
		titleText ["", "PLAIN"];
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	};
	TF_last_request_time = time;
};
TF_radio_request_mutex = false;