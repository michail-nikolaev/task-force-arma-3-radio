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

_splitResult = _result splitString "";

if ((_result != "OK") and {(count _splitResult) != 2}) then {
    [parseText (_result), 10] call TFAR_fnc_showHint;
    tf_lastError = true;
} else {
    if (tf_lastError) then {
        call TFAR_fnc_hideHint;
        tf_lastError = false;
    };
};

private _isSpeaking = (_splitResult select 0) == "1";
private _isReceiving = (_splitResult select 1) == "1";

if (_isSpeaking) then {
    _player setVariable ["TFAR_speakingSince", diag_tickTime];
};

_player setRandomLip _isSpeaking;
//Only want to fire EH once
if !((_player getVariable ["TFAR_isSpeaking", false]) isEqualTo _isSpeaking) then {
    _player setVariable ["TFAR_isSpeaking", _isSpeaking];
    _player setVariable ["TF_isSpeaking", _isSpeaking];//#Deprecated variable
    ["OnSpeak", [_player, _isSpeaking]] call TFAR_fnc_fireEventHandlers;
};

if !((_player getVariable ["TFAR_isReceiving", false]) isEqualTo _isReceiving) then {
    _player setVariable ["TFAR_isReceiving", _isReceiving];
    ["OnRadioReceive", [_player, _isReceiving]] call TFAR_fnc_fireEventHandlers;
};



if !(_player getVariable ["TFAR_killedEHAttached",false]) then {
    _player addEventHandler ["Killed", {_player call TFAR_fnc_sendPlayerKilled}];
    _player setVariable ["TFAR_killedEHAttached", true];
};
