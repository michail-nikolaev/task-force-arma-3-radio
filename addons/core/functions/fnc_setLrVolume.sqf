#include "script_component.hpp"

/*
  Name: TFAR_fnc_setLrVolume

  Author: NKey
    Sets the volume for the passed radio

  Arguments:
    0: LR Radio <ARRAY>
    1: Volume Range (0,10) <NUMBER>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeLrRadio, 5] call TFAR_fnc_setLrVolume;

  Public: Yes
*/
params [["_radio", [], [[]], 2], ["_value", 0, [0]]];
_radio params ["_radio_object", "_radio_qualifier"];

[_radio, _value] call TFAR_fnc_setRadioVolume;

// Unit, radio object, radio ID, volume, additional channel
["OnLRvolumeSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _value, false]] call TFAR_fnc_fireEventHandlers;
