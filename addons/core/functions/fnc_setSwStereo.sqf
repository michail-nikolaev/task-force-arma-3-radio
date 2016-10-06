#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwStereo

    Author(s):
        NKey

    Description:
        Sets the stereo setting for the SW radio

    Parameters:
    0: STRING - Radio
    1: NUMBER - Stereo : Range (0,2) (0 - Both, 1 - Left, 2 - Right)

    Returns:
        Nothing

    Example:
        [(call TFAR_fnc_ActiveSWRadio), 2] call TFAR_fnc_setSwStereo;
 */

private ["_settings"];

params ["_radio_id", "_value_to_set"];

if ((_radio_id call TFAR_fnc_getAdditionalSwChannel) == (_radio_id call TFAR_fnc_getSwChannel)) then {
    _this call TFAR_fnc_setAdditionalSwStereo;
} else {
    _settings = _radio_id call TFAR_fnc_getSwSettings;
    _settings set [TF_SW_STEREO_OFFSET, _value_to_set];
    [_radio_id, _settings] call TFAR_fnc_setSwSettings;

    //							unit, radio ID,	stero, additional
    ["OnSWstereoSet", TFAR_currentUnit, [TFAR_currentUnit, _radio_id, _value_to_set, false]] call TFAR_fnc_fireEventHandlers;
};
