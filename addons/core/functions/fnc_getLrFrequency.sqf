#include "script_component.hpp"

/*
  Name: TFAR_fnc_getLrFrequency

  Author: NKey, Garth de Wet (L-H)
    Gets the frequency for the active channel.

  Arguments:
    0: Radio object <OBJECT>
    1: Radio ID <STRING>

  Return Value:
    Frequency <NUMBER>

  Example:
    _frequency = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrFrequency;

  Public: Yes
*/

[_this, ((_this call TFAR_fnc_getLrSettings) param [ACTIVE_CHANNEL_OFFSET])+1] call TFAR_fnc_getChannelFrequency;
