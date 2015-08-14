/*
 	Name: TFAR_fnc_sendPlayerInfo
 	
 	Author(s):
		NKey

 	Description:
		Notifies the plugin about a player
	
	Parameters:
		1: OBJECT - Unit
<<<<<<< HEAD
		2: BOOLEAN - Is unit close to player
		3: STRING - Unit name

=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Returns:
		Nothing
 	
 	Example:
		[player] call TFAR_fnc_sendPlayerInfo;
*/
<<<<<<< HEAD
private ["_request","_result", "_player", "_isNearPlayer", "_killSet"];
=======
private ["_request","_result", "_player", "_isNearPlayer"];
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
_player = _this select 0;

_request = _this call TFAR_fnc_preparePositionCoordinates;
_result = "task_force_radio_pipe" callExtension _request;

<<<<<<< HEAD
if ((_result != "OK") and {_result != "SPEAKING"} and {_result != "NOT_SPEAKING"}) then {
=======
if ((_result != "OK") and {_result != "SPEAKING"} and {_result != "NOT_SPEAKING"}) then 
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
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
<<<<<<< HEAD
	if (!(_player getVariable ["tf_isSpeaking", false])) then {
		_player setVariable ["tf_isSpeaking", true];
		["OnSpeak", _player, [_player, true]] call TFAR_fnc_fireEventHandlers;
	};
	_player setVariable ["tf_start_speaking", diag_tickTime];
} else {
	_player setRandomLip false;
	if ((_player getVariable ["tf_isSpeaking", false])) then {
		_player setVariable ["tf_isSpeaking", false];
		["OnSpeak", _player, [_player, false]] call TFAR_fnc_fireEventHandlers;
	};
};
_killSet = _player getVariable "tf_killSet";
if (isNil "_killSet") then {
	_player addEventHandler ["Killed", {(_this select 0) call TFAR_fnc_sendPlayerKilled}];
	_player setVariable ["tf_killSet", true];
};
=======
	_player setVariable ["tf_start_speaking", diag_tickTime];
} else {
	_player setRandomLip false;
};
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
