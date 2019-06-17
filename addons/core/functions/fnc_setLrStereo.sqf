#include "script_component.hpp"

/*
  Name: TFAR_fnc_setLrStereo

  Author: NKey
    Sets the stereo setting for the passed radio

  Arguments:
    0: LR Radio <ARRAY>
    1:  Stereo setting  Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeLrRadio, 1] call TFAR_fnc_setLrStereo;

  Public: Yes
*/
params [["_radio", [], [[]], 2], ["_value", 0, [0]]];
_radio params ["_radio_object", "_radio_qualifier"];

if ((_radio call TFAR_fnc_getAdditionalLrChannel) == (_radio call TFAR_fnc_getLrChannel)) exitWith {
    _this call TFAR_fnc_setAdditionalLrStereo;
};

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [TFAR_LR_STEREO_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setLrSettings;

//							unit, radio object,		radio ID			channel, additional
["OnLRstereoSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, false]] call TFAR_fnc_fireEventHandlers;
