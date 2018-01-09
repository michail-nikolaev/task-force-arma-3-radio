#include "script_component.hpp"

/*
  Name: TFAR_fnc_getAdditionalSwStereo

  Author: NKey
    Gets the stereo setting of additional channel of the passed radio

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>

  Example:
    _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getAdditionalSwStereo;

  Public: Yes
 */

params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [TFAR_ADDITIONAL_STEREO_OFFSET]
