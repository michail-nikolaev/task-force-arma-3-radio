#include "script_component.hpp"

/*
  Name: TFAR_fnc_getLrSpeakers

  Author: NKey
    Gets the speakers setting of the passed radio

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    speakers or headphones <BOOL>

  Example:
    _speakers = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSpeakers;

  Public: Yes
*/

(_this call TFAR_fnc_getLrSettings) param [TFAR_LR_SPEAKER_OFFSET,false]
