#include "script_component.hpp"

/*
    Name: TFAR_fnc_setAdditionalSwStereo

    Author(s):
        NKey

    Description:
        Sets the stereo setting for additional channel the SW radio

    Parameters:
    0: STRING - Radio
    1: NUMBER - Stereo : Range (0,2) (0 - Both, 1 - Left, 2 - Right)

    Returns:
        Nothing

    Example:
        [(call TFAR_fnc_ActiveSWRadio), 2] call TFAR_fnc_setAdditionalSwStereo;
 */

params ["_radio_id", "_channel_to_set"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [TF_ADDITIONAL_STEREO_OFFSET, _value_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,	stero, additional
["OnSWstereoSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_id, _value_to_set, true]] call TFAR_fnc_fireEventHandlers;
