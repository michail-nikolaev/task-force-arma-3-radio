#include "script_component.hpp"

/*
  Name: TFAR_fnc_setSwVolume

  Author: NKey
    Sets the volume for the SW radio

  Arguments:
    0: Radio <STRING>
    1: Volume Range (0,10) <NUMBER>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeSWRadio, 10] call TFAR_fnc_setSwVolume;

  Public: Yes
*/

params ["_radio_id", "_value"];

[_radio_id, _value] call TFAR_fnc_setRadioVolume;

// Unit, radio ID, volume, additional channel
["OnSWvolumeSet", [TFAR_currentUnit, _radio_id, _value, false]] call TFAR_fnc_fireEventHandlers;
