#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwSpeakers

    Author(s):
        NKey

    Description:
        Sets the speakers setting for the SW radio

    Parameters:
        0: STRING - Radio

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeSWRadio] call TFAR_fnc_setSwSpeakers;
*/

params ["_radio_id"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
private _currentlyEnabled = _settings select TFAR_SW_SPEAKER_OFFSET;
if (_currentlyEnabled) then {
    _settings set [TFAR_SW_SPEAKER_OFFSET, false];
} else {
    _settings set [TFAR_SW_SPEAKER_OFFSET, true];
};

private _flag = TFAR_currentUnit getVariable ["TFAR_SRSpeakersEnabled",scriptNull];
if !(_flag isEqualTo _currentlyEnabled) then {
    TFAR_currentUnit setVariable ["TFAR_SRSpeakersEnabled", true, true];
};

[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//									unit, radio ID,	speakers
["OnSWspeakersSet", [TFAR_currentUnit, _radio_id, _settings select TFAR_SW_SPEAKER_OFFSET]] call TFAR_fnc_fireEventHandlers;
