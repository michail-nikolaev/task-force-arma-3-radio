#include "script_component.hpp"

/*
  Name: TFAR_fnc_setSwFrequency

  Author: NKey, Garth de Wet (L-H)
    Sets the frequency for the currently active channel

  Arguments:
    0: Radio classname <STRING>
    1: Frequency <STRING>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeSwRadio, "76.2"] call TFAR_fnc_setSwFrequency;

  Public: Yes
*/

params ["_radio", "_freq"];

[_radio, ((_radio call TFAR_fnc_getSwSettings) select ACTIVE_CHANNEL_OFFSET)+1, _freq] call TFAR_fnc_setChannelFrequency;
