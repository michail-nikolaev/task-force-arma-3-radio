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
        [(call TFAR_fnc_activeSWRadio), 2] call TFAR_fnc_setAdditionalSwStereo;
 */
params [["_radio","",[""]], ["_value",0,[0]]];

private _settings = _radio call TFAR_fnc_getSwSettings;
_settings set [TFAR_ADDITIONAL_STEREO_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,	stero, additional
["OnSWstereoSet", [TFAR_currentUnit, _radio, _value, true]] call TFAR_fnc_fireEventHandlers;
