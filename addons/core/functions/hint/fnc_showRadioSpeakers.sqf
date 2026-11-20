#include "script_component.hpp"

/*
  Name: TFAR_fnc_showRadioSpeakers

  Author: Garth de Wet (L-H), Nkey
    shows the speaker hint

  Arguments:
    0: Radio <ARRAY|STRING>

  Return Value:
    None

  Example:
    // LR radio
    [(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_showRadioSpeakers;
    // SW radio
    [(call TFAR_fnc_activeSwRadio)] call TFAR_fnc_showRadioSpeakers;

  Public: Yes
*/
params ["_radio"];
[_radio, false, true] call TFAR_fnc_showRadioVolume;
