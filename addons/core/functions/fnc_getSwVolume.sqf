#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSwVolume

  Author: NKey
    Gets the volume of the passed radio

  Arguments:
    Radio classname <STRING>

  Return Value:
    Volume : range (0,10) <NUMBER>

  Example:
    _volume = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwVolume;

  Public: Yes
 */

params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [VOLUME_OFFSET, false]
