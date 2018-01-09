#include "script_component.hpp"

/*
  Name: TFAR_fnc_setAdditionalLrStereo

  Author: NKey
    Sets the stereo setting for additional channel the passed radio

  Arguments:
    0: LR Radio <ARRAY>
    1: Stereo setting  Range (0,2) (0 - Both, 1 - Left, 2 - Right)) <NUMBER>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeLrRadio, 1] call TFAR_fnc_setAdditionalLrStereo;

  Public: Yes
 */
params [["_radio", [], [[]], 2], ["_value", 0, [0]]];
_radio params ["_radio_object", "_radio_qualifier"];

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [TFAR_ADDITIONAL_STEREO_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			channel, additional
["OnLRstereoSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, true]] call TFAR_fnc_fireEventHandlers;
