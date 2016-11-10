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

private _isSpeaking = (_result == "SPEAKING");
if (_isSpeaking) then {
    _player setVariable ["TFAR_speakingSince", diag_tickTime];
};

_player setRandomLip _isSpeaking;
//Only want to fire EH once
if !((_player getVariable ["TFAR_isSpeaking", false]) isEqualTo _isSpeaking) then {
    _player setVariable ["TFAR_isSpeaking", _isSpeaking];
    ["OnSpeak", [_player, _isSpeaking]] call TFAR_fnc_fireEventHandlers;
};

if !(_player getVariable ["TFAR_killedEHAttached",false]) then {
    _player addEventHandler ["Killed", {_player call TFAR_fnc_sendPlayerKilled}];
    _player setVariable ["TFAR_killedEHAttached", true];
};
