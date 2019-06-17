#include "script_component.hpp"

/*
  Name: TFAR_fnc_OnRadioReceive

  Author: Dorbedo
    Event called upon receving a radio call

  Arguments:
    0: receving unit <OBJECT>
    1: is receving <BOOL>

  Return Value:
    None

  Example:
    [_unit, _isReceiving] call TFAR_ai_hearing_fnc_onRadioReceive;

  Public: No
*/

params [["_unit", objNull, [objNull]], ["_isReceiving", false, [true]]];

if !(_isReceiving) exitWith {};

if ((_unit getVariable ["TFAR_LRSpeakersEnabled", false]) || {_unit getVariable ["TFAR_SRSpeakersEnabled", false]}) exitWith {
    [_unit, TF_speakerDistance] call FUNC(revealInArea);
};
