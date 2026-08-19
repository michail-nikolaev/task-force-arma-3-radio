#include "script_component.hpp"

/*
  Name: TFAR_fnc_getAdditionalSwVolume

  Author: Darojax
    Gets the listening volume for the additional channel of an SW radio.
    Legacy settings without a separate value inherit the main channel volume.

  Arguments:
    Radio classname <STRING>

  Return Value:
    Volume: range (0,10) <NUMBER>

  Example:
    _volume = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getAdditionalSwVolume;

  Public: Yes
*/

params [["_radio", "", [""]]];

private _settings = _radio call TFAR_fnc_getSwSettings;
_settings param [TFAR_ADDITIONAL_VOLUME_OFFSET, _settings param [VOLUME_OFFSET, 0]]
