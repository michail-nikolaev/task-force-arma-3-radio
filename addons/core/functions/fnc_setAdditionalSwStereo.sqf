#include "script_component.hpp"

/*
  Name: TFAR_fnc_setAdditionalSwStereo

  Author: NKey
    Sets the stereo setting for additional channel the SW radio

  Arguments:
    0: Radio <STRING>
    1: Stereo Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>

  Return Value:
    None

  Example:
    [(call TFAR_fnc_activeSWRadio), 2] call TFAR_fnc_setAdditionalSwStereo;

  Public: Yes
 */
params [["_radio", "", [""]], ["_value", 0, [0]]];

private _settings = _radio call TFAR_fnc_getSwSettings;
_settings set [TFAR_ADDITIONAL_STEREO_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setSwSettings;

//							unit, radio ID,	stero, additional
["OnSWstereoSet", [TFAR_currentUnit, _radio, _value, true]] call TFAR_fnc_fireEventHandlers;
