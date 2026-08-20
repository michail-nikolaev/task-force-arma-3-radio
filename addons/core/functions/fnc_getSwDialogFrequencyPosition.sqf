#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSwDialogFrequencyPosition

  Author: Darojax
    Returns the unmodified frequency-control position relative to the channel
    control, allowing movable radio dialogs to retain their current location.

  Arguments:
    0: Frequency edit control <CONTROL>

  Return Value:
    Frequency control position <ARRAY>

  Public: No
*/

params [["_frequencyControl", controlNull, [controlNull]]];

[_frequencyControl, SW_CHANNEL] call TFAR_fnc_getRadioDialogFrequencyPosition
