/*
 	Name: TFAR_fnc_sendPlayerInfo
 	
 	Author(s):
		NKey

 	Description:
		Notifies the plugin about a player
	
	Parameters:
		1: OBJECT - Unit
 	
 	Returns:
		Nothing
 	
 	Example:
		[player] call TFAR_fnc_sendPlayerInfo;
*/
private ["_request","_result", "_player", "_isNearPlayer"];
_player = _this select 0;

_request = _this call TFAR_fnc_preparePositionCoordinates;
_result = "task_force_radio_pipe" callExtension _request;

if ((_result != "OK") and {_result != "SPEAKING"} and {_result != "NOT_SPEAKING"}) then {
	[parseText (_result), 10] call TFAR_fnc_showHint;
	tf_lastError = true;
} else {
	if (tf_lastError) then {
		call TFAR_fnc_hideHint;
		tf_lastError = false;
	};
};
if (_result == "SPEAKING") then {
	_player setRandomLip true;
	_player setVariable ["tf_start_speaking", diag_tickTime];
} else {
	_player setRandomLip false;
};