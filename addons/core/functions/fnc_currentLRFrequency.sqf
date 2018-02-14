#include "script_component.hpp"

/*
  Name: TFAR_fnc_currentLRFrequency

  Author: NKey
    Returns current Frequency of the active LR Radio

  Arguments:
    None

  Return Value:
    Frequency of active LR Radio <STRING>

  Example:
    _LRFrequency = call TFAR_fnc_currentLRFrequency

  Public: Yes
 */

(call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrFrequency
