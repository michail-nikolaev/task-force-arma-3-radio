#include "script_component.hpp"

/*
    Name: TFAR_ai_hearing_fnc_onRadioReceive

    Author(s):
        Dorbedo

    Description:
        Event called upon receving a radio call

    Parameters:
        0: the receving Unit <OBJECT>
        1: is receiving <BOOL>

    Returns:
        NOTHING

    Example:
        [_unit, _isReceiving] call TFAR_ai_hearing_fnc_onRadioReceive;
*/

params [["_unit", objNull, [objNull]], ["_isReceiving", false, [true]]];

If !(_isReceiving) exitWith {};

If ((_unit getVariable ["TFAR_LRSpeakersEnabled", false]) || {_unit getVariable ["TFAR_SRSpeakersEnabled", false]}) exitWith {
    [_unit, TF_speakerDistance] call FUNC(revealInArea);
};
