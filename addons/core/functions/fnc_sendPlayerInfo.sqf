#include "script_component.hpp"

/*
    Name: TFAR_fnc_sendPlayerInfo

    Author(s):
        NKey

    Description:
        Notifies the plugin about a player

    Parameters:
        1: OBJECT - Unit
        2: BOOLEAN - Is unit close to player
        3: STRING - Unit name


    Returns:
        Nothing

    Example:
        [player] call TFAR_fnc_sendPlayerInfo;
*/

params ["_player"];

private _request = _this call TFAR_fnc_preparePositionCoordinates;
private _result = "task_force_radio_pipe" callExtension _request;

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
private _killSet = _player getVariable "tf_killSet";
if (isNil "_killSet") then {
    _player addEventHandler ["Killed", {_player call TFAR_fnc_sendPlayerKilled}];
    _player setVariable ["tf_killSet", true];
};
