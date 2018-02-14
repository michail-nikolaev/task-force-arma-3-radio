#include "script_component.hpp"

/*
  Name: TFAR_fnc_setSwStereo

  Author: NKey
    Sets the stereo setting for the SW radio

  Arguments:
    0: Radio <STRING>
    1: Stereo Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>

  Return Value:
    return name <TYPENAME>

  Example:
    [call TFAR_fnc_activeSWRadio, 2] call TFAR_fnc_setSwStereo;

  Public: Yes
*/

params ["_radio_id", "_value_to_set"];

if ((_radio_id call TFAR_fnc_getAdditionalSwChannel) == (_radio_id call TFAR_fnc_getSwChannel)) exitWith {
    _this call TFAR_fnc_setAdditionalSwStereo;
};

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [TFAR_SW_STEREO_OFFSET, _value_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,	stero, additional
["OnSWstereoSet", [TFAR_currentUnit, _radio_id, _value_to_set, false]] call TFAR_fnc_fireEventHandlers;
