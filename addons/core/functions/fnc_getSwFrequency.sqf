#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSwFrequency

  Author: NKey, Garth de Wet (L-H)
    Gets the frequency for the active channel.

  Arguments:
    Radio classname <STRING>

  Return Value:
    Frequency <NUMBER>

  Example:
    _frequency = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwFrequency;

  Public: Yes
*/

params[["_radio", "", [""]]];

[_radio, ((_radio call TFAR_fnc_getSwSettings) param [ACTIVE_CHANNEL_OFFSET,0])+1] call TFAR_fnc_getChannelFrequency;
