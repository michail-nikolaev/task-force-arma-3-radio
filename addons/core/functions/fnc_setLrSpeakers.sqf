#include "script_component.hpp"

/*
  Name: TFAR_fnc_setLrSpeakers

  Author: NKey
    Sets the speakers setting for the passed radio

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    None

  Example:
    (call TFAR_fnc_activeLrRadio) call TFAR_fnc_setLrSpeakers;

  Public: Yes
*/

params ["_radio_object", "_radio_qualifier"];

private _settings = [_radio_object, _radio_qualifier] call TFAR_fnc_getLrSettings;
private _currentlyEnabled = _settings select TFAR_LR_SPEAKER_OFFSET;
if (_currentlyEnabled) then {
    _settings set [TFAR_LR_SPEAKER_OFFSET, false];
} else {
    _settings set [TFAR_LR_SPEAKER_OFFSET, true];
};

private _flag = TFAR_currentUnit getVariable ["TFAR_LRSpeakersEnabled",scriptNull];
if !(_flag isEqualTo _currentlyEnabled) then {
    TFAR_currentUnit setVariable ["TFAR_LRSpeakersEnabled", true, true];
};

_flag = _radio_object getVariable ["TFAR_LRSpeakersEnabled",scriptNull];
if !(_flag isEqualTo _currentlyEnabled) then {
    _radio_object setVariable ["TFAR_LRSpeakersEnabled", true, true];
};

[[_radio_object, _radio_qualifier], _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			speakers
["OnLRspeakersSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _settings select TFAR_LR_SPEAKER_OFFSET]] call TFAR_fnc_fireEventHandlers;
