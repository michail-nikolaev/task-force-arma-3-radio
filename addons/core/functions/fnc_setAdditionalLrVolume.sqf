#include "script_component.hpp"

/*
  Name: TFAR_fnc_setAdditionalLrVolume

  Author: Darojax
    Sets the listening volume for the additional channel of an LR radio.

  Arguments:
    0: LR Radio <ARRAY>
    1: Volume Range (0,10) <NUMBER>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeLrRadio, 5] call TFAR_fnc_setAdditionalLrVolume;

  Public: Yes
*/

params [["_radio", [], [[]], 2], ["_value", 0, [0]]];
_radio params ["_radio_object", "_radio_qualifier"];

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [TFAR_ADDITIONAL_VOLUME_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setLrSettings;

// Unit, radio object, radio ID, volume, additional channel
["OnLRvolumeSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, true]] call TFAR_fnc_fireEventHandlers;
