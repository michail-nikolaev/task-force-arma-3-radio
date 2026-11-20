#include "script_component.hpp"

/*
  Name: TFAR_fnc_setAdditionalSwVolume

  Author: Darojax
    Sets the listening volume for the additional channel of an SW radio.

  Arguments:
    0: Radio <STRING>
    1: Volume Range (0,10) <NUMBER>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeSwRadio, 5] call TFAR_fnc_setAdditionalSwVolume;

  Public: Yes
*/

params ["_radio_id", "_value"];

[_radio_id, _value, true] call TFAR_fnc_setRadioVolume;

// Unit, radio ID, volume, additional channel
["OnSWvolumeSet", [TFAR_currentUnit, _radio_id, _value, true]] call TFAR_fnc_fireEventHandlers;
