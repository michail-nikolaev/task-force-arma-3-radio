#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrSpeakers

    Author(s):
        NKey

    Description:
        Sets the speakers setting for the passed radio

    Parameters:
        0: OBJECT - Radio object
        1: STRING - Radio ID

    Returns:
        Nothing

    Example:
        [(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1] call TFAR_fnc_setLrSpeakers;
*/

params ["_radio_object", "_radio_qualifier"];

private _settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
if (_settings select TFAR_LR_SPEAKER_OFFSET) then {
    _settings set [TFAR_LR_SPEAKER_OFFSET, false];
} else {
    _settings set [TFAR_LR_SPEAKER_OFFSET, true];
    private _flag = TFAR_currentUnit getVariable "TFAR_LRSpeakersEnabled";
    if (isNil "_flag") then {
        TFAR_currentUnit setVariable ["TFAR_LRSpeakersEnabled", true, true];
    };
    _flag = _radio_object getVariable "TFAR_LRSpeakersEnabled";
    if (isNil "_flag") then {
        _radio_object setVariable ["TFAR_LRSpeakersEnabled", true, true];
    };
};
[_radio_object, _radio_qualifier, _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			speakers
["OnLRspeakersSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _settings select TF_LR_SPEAKER_OFFSET]] call TFAR_fnc_fireEventHandlers;
