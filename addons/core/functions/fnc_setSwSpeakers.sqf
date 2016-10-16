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
        [call TFAR_fnc_ActiveSWRadio] call TFAR_fnc_setSwSpeakers;
*/

params ["_radio_id"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
if (_settings select TF_SW_SPEAKER_OFFSET) then {
    _settings set [TF_SW_SPEAKER_OFFSET, false];
} else {
    _settings set [TF_SW_SPEAKER_OFFSET, true];
    private _flag = TFAR_currentUnit getVariable "tf_sw_speakers";
    if (isNil "_flag") then {
        TFAR_currentUnit setVariable ["tf_sw_speakers", true, true];
    };
};
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//									unit, radio ID,	speakers
["OnSWspeakersSet", [TFAR_currentUnit, _radio_id, _settings select TF_SW_SPEAKER_OFFSET]] call TFAR_fnc_fireEventHandlers;
